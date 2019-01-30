pragma solidity ^0.4.24;

import "@aragon/os/contracts/apps/AragonApp.sol";
import "@aragon/os/contracts/lib/math/SafeMath.sol";
import "@aragon/os/contracts/lib/token/ERC20.sol";

import "./Community.sol";


contract Member is AragonApp, Community {

    bytes32 public constant ISSUE_ROLE = keccak256("ISSUE_ROLE");
    bytes32 public constant MINT_ROLE = keccak256("MINT_ROLE");
    bytes32 public constant TRANSFER_ROLE = keccak256("TRANSFER_ROLE");
    bytes32 public constant ASSIGN_ROLE = keccak256("ASSIGN_ROLE");

    struct CoinIssuing {
        bytes32 coinId;
        string space;
        uint256 amount;
    }
    
    ERC20 public token;

    mapping(address => mapping(bytes32 => CoinIssuing)) public coins;

    function initialize() public onlyInit {
        initialized();
    }

    /**
     * @notice function to create new space
     * @param _name space name
     * @param _desc space description
     * @param _members list of members addresses
     */
    function createSpace(string _name, string _desc, address[] _members) public {
        require(VerifyMembers(_members), "invalid member address");
        
        bytes32 spaceId = keccak256(abi.encodePacked(_name));
        _createSpace(spaceId, _name, _desc, msg.sender, _members);
    }

    /**
     * @notice function to verify addresses
     * @param _members list of addresses
     * @return true if all addresses are valid, otherwise return false
     */
    function VerifyMembers(address[] _members) internal pure returns(bool) {
        for(uint i = 0; i < _members.length; i++) {
            if(_members[i] == address(0)) {
                return false;
            }
        }
        return true;
    }
}