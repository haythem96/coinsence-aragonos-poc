pragma solidity ^0.4.24;


//import "./KitBase.sol";
import "@aragon/os/contracts/apps/AragonApp.sol";
//import "@aragon/os/contracts/kernel/Kernel.sol";
//import "@aragon/os/contracts/acl/ACL.sol";

import "@aragon/os/contracts/common/IForwarder.sol";

import "@aragon/os/contracts/lib/math/SafeMath.sol";


contract Community is IForwarder, AragonApp {

    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");
    bytes32 public constant ISSUE_TOKEN_ROLE = keccak256("ISSUE_TOKEN_ROLE");

    string private constant ERROR_CAN_NOT_FORWARD = "TM_CAN_NOT_FORWARD";

    ///@notice space name 
    string private _name;

    ///@notice space owner
    address private _owner;

    ///@notice space members
    address[] public _members;

    function initialize(string name, address[] members) public onlyInit {
        require(verifyMembers(members), "invalid member address");

        _name = name;
        _owner = msg.sender;
        _members = members;

        initialized();
    }

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
     * @notice function to check if member address already exist in the space
     * @param member address
     */
    function doesExist(address member) internal view returns(bool) {
        for(uint i = 0; i < _members.length; i++) {
            if(_members[i] == member) {
                return true;
            }
        }
        return false;
    }

    /**
     * @notice function to add member to a space
     * @param member address
     */
    function addMember(address member) public auth(MANAGER_ROLE) {
        require(member != address(0), "invalid member address");
        require(member != msg.sender, "you can't add urself!");
        require(!doesExist(member), "member already exist in the space");

        _members.push(member);
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