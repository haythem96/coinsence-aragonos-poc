pragma solidity ^0.4.24;


import "./KitBase.sol";
import "@aragon/os/contracts/kernel/Kernel.sol";
import "@aragon/os/contracts/acl/ACL.sol";

contract SpaceKit is KitBase {

    constructor(
        ENS _ens
    ) KitBase(DAOFactory(0), _ens) public {
    }

    function newInstance(
        bytes32 appId, 
        bytes32[] roles, 
        address authorizedAddress
        //bytes initializeCalldata
    ) public returns (Kernel dao, ERCProxy proxy) {
        address root = msg.sender;
        dao = fac.newDAO(this);
        ACL acl = ACL(dao.acl());

        acl.createPermission(this, dao, dao.APP_MANAGER_ROLE(), this);

        // If there is no appId, an empty DAO will be created
        if (appId != bytes32(0)) {
            proxy = dao.newAppInstance(appId, latestVersionAppBase(appId));

            for (uint256 i = 0; i < roles.length; i++) {
                acl.createPermission(authorizedAddress, proxy, roles[i], root);
            }

            emit InstalledApp(proxy, appId);
        }

        cleanupDAOPermissions(dao, acl, root);

        emit DeployInstance(dao);
    }

}