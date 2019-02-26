pragma solidity ^0.4.24;


import "@aragon/os/contracts/factory/DAOFactory.sol";
import "@aragon/os/contracts/apm/Repo.sol";
import "@aragon/os/contracts/lib/ens/ENS.sol";
import "@aragon/os/contracts/lib/ens/PublicResolver.sol";
//import "@aragon/os/contracts/evmscript/IEVMScriptRegistry.sol"; // needed for EVMSCRIPT_REGISTRY_APP_ID
import "@aragon/os/contracts/apm/APMNamehash.sol";

import "./Community.sol";

contract KitBase is APMNamehash {
    ENS public ens;
    DAOFactory public fac;

    event DeployInstance(address dao);
    event InstalledApp(address appProxy, bytes32 appId);

    constructor (ENS _ens) public {
        ens = _ens;

        bytes32 bareKit = apmNamehash("bare-kit");
        fac = KitBase(latestVersionAppBase(bareKit)).fac();
    }

    function latestVersionAppBase(bytes32 appId) public view returns (address base) {
        Repo repo = Repo(PublicResolver(ens.resolver(appId)).addr(appId));
        (,base,) = repo.getLatest();

        return base;
    }

    function cleanupDAOPermissions(Kernel dao, ACL acl, address root) internal {
        // Kernel permission clean up
        cleanupPermission(acl, root, dao, dao.APP_MANAGER_ROLE());

        // ACL permission clean up
        cleanupPermission(acl, root, acl, acl.CREATE_PERMISSIONS_ROLE());
    }

    function cleanupPermission(ACL acl, address root, address app, bytes32 permission) internal {
        acl.grantPermission(root, app, permission);
        acl.revokePermission(this, app, permission);
        acl.setPermissionManager(root, app, permission);
    }
}

contract Kit is KitBase {

    constructor(
        ENS _ens
    ) KitBase(_ens) public {
    }

    //returns (Kernel dao, ERCProxy space)

    function newInstance() public {
        bytes32[1] memory appIds = [
            apmNamehash("coinsence-aragon")       // 0
        ];

        address root = msg.sender;
        Kernel dao = fac.newDAO(this);
        ACL acl = ACL(dao.acl());

        acl.createPermission(this, dao, dao.APP_MANAGER_ROLE(), this);

        // Apps
        Community space = Community(
            dao.newAppInstance(
                appIds[0],
                latestVersionAppBase(appIds[0])
            )
        );
        emit InstalledApp(space, appIds[0]);

        //Community roles
        acl.createPermission(msg.sender, space, space.MANAGER_ROLE(), root);
        acl.createPermission(msg.sender, space, space.ISSUE_TOKEN_ROLE(), root);

        cleanupDAOPermissions(dao, acl, root);

        emit DeployInstance(dao);
    }

}