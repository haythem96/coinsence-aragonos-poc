pragma solidity ^0.4.24;


import "@aragon/os/contracts/apps/AragonApp.sol";
import "./lib/aragon/IACLEnhanced.sol";
//import "@aragon/os/contracts/kernel/IKernel.sol";
//import "@aragon/os/contracts/acl/ACL.sol";

contract Community is AragonApp {

    IACLEnhanced public acl;

    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");
    bytes32 public constant ISSUE_TOKEN_ROLE = keccak256("ISSUE_TOKEN_ROLE");

    string private constant ERROR_CAN_NOT_FORWARD = "TM_CAN_NOT_FORWARD";

    ///@notice space name 
    string private _name;

    ///@notice space owner
    address private _owner;

    ///@notice space members
    address[] public _members;

    mapping(address => bool) public isMember;

    function initialize(string name, address[] members) public onlyInit {
        require(verifyMembers(members), "invalid member address");

        _name = name;
        _owner = msg.sender;
        _members = members;

        _members.push(msg.sender);
        isMember[msg.sender] = true;

        acl = IACLEnhanced(kernel().acl());

        acl.createPermission(
            msg.sender,
            this,
            MANAGER_ROLE,
            msg.sender
        );

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
     * @notice function to add member to a space
     * @param member address
     */
    function addMember(address member) public auth(MANAGER_ROLE) {
        require(member != address(0), "invalid member address");
        require(member != msg.sender, "you can't add urself!");
        require(!isMember[member], "member already exist in the space");

        _members.push(member);
        isMember[member] = true;
    }


}