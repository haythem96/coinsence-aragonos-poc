pragma solidity ^0.4.24;

import "@aragon/os/contracts/factory/DAOFactory.sol";
import "@aragon/os/contracts/kernel/Kernel.sol";
import "@aragon/os/contracts/acl/ACL.sol";
import "@aragon/os/contracts/apm/Repo.sol";
import "@aragon/os/contracts/lib/ens/ENS.sol";
import "@aragon/os/contracts/lib/ens/PublicResolver.sol";
//import "@aragon/os/contracts/evmscript/IEVMScriptRegistry.sol"; // needed for EVMSCRIPT_REGISTRY_APP_ID
import "../node_modules/@aragon/os/contracts/apm/APMNamehash.sol";


contract KitBase is APMNamehash {
    ENS public ens;
    DAOFactory public fac;

    event DeployInstance(address dao);
    event InstalledApp(address appProxy, bytes32 appId);

    constructor (DAOFactory _fac, ENS _ens) public {
        ens = _ens;

        // If no factory is passed, get it from on-chain bare-kit
        if (address(_fac) == address(0)) {
            bytes32 bareKit = apmNamehash("bare-kit");
            fac = KitBase(latestVersionAppBase(bareKit)).fac();
        } else {
            fac = _fac;
        }
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

contract SpaceKit is KitBase {

    constructor(
        ENS _ens
    ) KitBase(DAOFactory(0), _ens) public {
    }

    function newInstance(
        bytes32 appId, 
        bytes32[] roles, 
        address authorizedAddress,
        bytes initializeCalldata
    ) public returns (Kernel dao, ERCProxy proxy) {
        address root = msg.sender;
        dao = fac.newDAO(this);
        ACL acl = ACL(dao.acl());

        acl.createPermission(this, dao, dao.APP_MANAGER_ROLE(), this);

        // If there is no appId, an empty DAO will be created
        if (appId != bytes32(0)) {
            proxy = dao.newAppInstance(appId, latestVersionAppBase(appId), initializeCalldata, false);

            for (uint256 i = 0; i < roles.length; i++) {
                acl.createPermission(authorizedAddress, proxy, roles[i], root);
            }

            emit InstalledApp(proxy, appId);
        }

        cleanupDAOPermissions(dao, acl, root);

        emit DeployInstance(dao);
    }

}