pragma solidity ^0.4.24;


//import "./KitBase.sol";
import "@aragon/os/contracts/apps/AragonApp.sol";
//import "@aragon/os/contracts/kernel/Kernel.sol";
//import "@aragon/os/contracts/acl/ACL.sol";

import "@aragon/os/contracts/common/IForwarder.sol";

import "@aragon/os/contracts/lib/math/SafeMath.sol";


contract Community is IForwarder, AragonApp {

    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");
    bytes32 public constant MINT_ROLE = keccak256("MINT_ROLE");

    string private constant ERROR_CAN_NOT_FORWARD = "TM_CAN_NOT_FORWARD";

    ///@notice space name 
    string private _name;

    ///@notice space owner
    address private _owner;

    ///@notice space members
    address[] private _members;

    /*
    constructor(
        DAOFactory _fac,
        ENS _ens,
        string name,
        address[] members
    ) KitBase(_fac, _ens) public {
        require(verifyMembers(members), "invalid member address");

        _name = name;
        _owner = msg.sender;
        _members = members;
    }
    */

    function initialize(string name, address[] members) public onlyInit {
        require(verifyMembers(members), "invalid member address");

        _name = name;
        _owner = msg.sender;
        _members = members;

        initialized();
    }

    /*
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
    */

    /**
     * @return the name of the space.
     */
    function name() public view isInitialized returns (string memory) {
        return _name;
    }

    /**
     * @return the owner of the space
     */
    function owner() public view isInitialized returns (address) {
        return _owner;
    }

    /**
     * @notice function to get member address from members array
     * @param position member index in the members array
     * @return address member
     */
    function getMemberAddress(uint256 position) public view isInitialized returns (address) {
        require(position < _members.length, "member not found");

        return _members[position];
    }

    /**
     * @notice function to get space members number
     * @return members number
     */
    function getMembersCount() public view isInitialized returns (uint256) {
        return _members.length;
    }

    /**
     * @notice function to verify addresses
     * @param members list of addresses
     * @return true if all addresses are valid, otherwise return false
     */
    function verifyMembers(address[] members) internal pure returns(bool) {
        for(uint i = 0; i < members.length; i++) {
            if(members[i] == address(0)) {
                return false;
            }
        }
        return true;
    }

    /**
     * @notice Execute desired action as a token holder
     * @dev IForwarder interface conformance. Forwards any token holder action.
     * @param _evmScript Script being executed
     */
    function forward(bytes _evmScript) public {
        require(canForward(msg.sender, _evmScript), ERROR_CAN_NOT_FORWARD);
        bytes memory input = new bytes(0); // TODO: Consider input for this

        address[] memory blacklist = new address[](1);
        blacklist[0] = address(this);

        runScript(_evmScript, input, blacklist);
    }

    function isForwarder() public pure returns (bool) {
        return true;
    }

    function canForward(address _sender, bytes _evmCallScript) public view returns (bool) {
        return hasInitialized() && canPerform(_sender, MANAGER_ROLE, arr());
    }

}