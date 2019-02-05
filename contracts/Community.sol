pragma solidity ^0.4.24;

import "@aragon/os/contracts/apps/AragonApp.sol";
import "@aragon/os/contracts/lib/math/SafeMath.sol";


contract Community is AragonApp {

    //space strcuture
    struct Space {
        bytes32 id;
        string name;
        string description;
        address owner;
        address[] members;
    }

    //number of spaces
    uint256 public spacesCount;

    mapping(bytes32 => Space) public spaces;
    mapping(address => uint256[]) public ownerSpaces;

    //list of all spaces
    bytes32[] public communities;

    /**
     * @notice function to be called by member to create new space
     * @param _name string space name
     * @param _desc string space description
     * @param _members Array of members addresses
     */
    function createSpace(string _name, string _desc, address _owner, address[] _members) public {
        require(verifyMembers(_members), "invalid member address");
        
        bytes32 spaceId = keccak256(abi.encodePacked(_name));
        Space memory community = Space(spaceId, _name, _desc, _owner, _members);
        //and new space and update total spaces number
        spaces[spaceId] = community;
        spacesCount = communities.push(spaceId);
        //get owner spaces
        uint256[] storage relatedSpaces = ownerSpaces[_owner];
        //add new space
        relatedSpaces.push(spacesCount);
    }

    /**
     * @notice function to verify addresses
     * @param _members list of addresses
     * @return true if all addresses are valid, otherwise return false
     */
    function verifyMembers(address[] _members) internal pure returns(bool) {
        for(uint i = 0; i < _members.length; i++) {
            if(_members[i] == address(0)) {
                return false;
            }
        }
        return true;
    }

    /**
     * @notice function to return number of spaces that belong to a member
     * @param _member member's address
     * @return spaces number
     */
    function getMemberSpacesCount(address _member) public view returns(uint256 count) {
        require(_member != address(0), "invalid address");

        return ownerSpaces[_member].length;
    } 

}