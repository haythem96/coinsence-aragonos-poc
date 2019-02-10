pragma solidity ^0.4.24;

import "@aragon/os/contracts/apps/AragonApp.sol";
import "@aragon/os/contracts/factory/DAOFactory.sol";
//import "@aragon/os/contracts/apm/APMNamehash.sol";

import "@aragon/os/contracts/lib/math/SafeMath.sol";


contract Community is AragonApp {

    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");

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

        acl.createPermission(_owner, this, MANAGER_ROLE, root);

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
     * @notice function to be called by member to create new space
     * @param _name string space name
     * @param _desc string space description
     * @param _members Array of members addresses
     */
    function getMembersCount() public view returns (uint256) {
        return _members.length;
    }

    /**
     * @notice function to verify addresses
     * @param _members list of addresses
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

}