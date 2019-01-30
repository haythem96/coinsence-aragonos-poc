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
    uint256 spacesCount;

    mapping(address => uint256[]) public ownerSpaces;

    //list of all spaces
    Space[] communities;

    function initialize() public onlyInit {
        initialized();
    }

    /**
     * @notice function to be called by member to create new space
     * @param _id bytes32 keccak256 of the space name
     * @param _name string space name
     * @param _desc string space description
     * @param _members Array of members addresses
     */
    function _createSpace(bytes32 _id, string _name, string _desc,address _owner, address[] _members) internal isInitialized {
        Space memory community = Space(_id, _name, _desc, _owner, _members);
        //and new space and update total spaces number
        spacesCount = communities.push(community);
        //get owner spaces
        uint256[] storage relatedSpaces = ownerSpaces[_owner];
        //add new space
        relatedSpaces.push(spacesCount);
        ownerSpaces[_owner] = relatedSpaces;
    }

}