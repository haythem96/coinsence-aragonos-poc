pragma solidity ^0.4.24;

import "../node_modules/@aragon/os/contracts/apps/AragonApp.sol";
import "../node_modules/@aragon/os/contracts/common/IForwarder.sol";
import "../node_modules/@aragon/os/contracts/factory/DAOFactory.sol";
//import "../node_modules/@aragon/os/contracts/apm/APMNamehash.sol";

import "../node_modules/@aragon/os/contracts/lib/math/SafeMath.sol";


contract Community is IForwarder, AragonApp {

    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");
    bytes32 public constant MINT_ROLE = keccak256("MINT_ROLE");

    string private constant ERROR_CAN_NOT_FORWARD = "TM_CAN_NOT_FORWARD";

    DAOFactory public fac;

    ///@notice space name 
    string private _name;

    ///@notice space owner
    address private _owner;

    ///@notice space members
    address[] private _members;

    function initialize(DAOFactory daoFactory, string name, address[] members) public onlyInit {
        require(verifyMembers(members), "invalid member address");

        Kernel dao = daoFactory.newDAO(this);
        ACL acl = ACL(dao.acl());
        acl.createPermission(this, dao, dao.APP_MANAGER_ROLE(), this);

        _name = name;
        _owner = msg.sender;
        _members = members;

        acl.createPermission(_owner, this, MANAGER_ROLE, this);

        initialized();
    }

    /**
     * @return the name of the space.
     */
    function name() public view returns (string memory) {
        return _name;
    }

    /**
     * @return the owner of the space
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     */
    function getMemberAddress(uint256 position) public view returns (address) {
        require(position < _members.length, "member not found");

        return _members[position];
    }

    /**
     * @notice function to get space members number
     * @return members number
     */
    function getMembersCount() public view returns (uint256) {
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