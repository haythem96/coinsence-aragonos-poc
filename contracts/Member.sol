pragma solidity ^0.4.24;

import "@aragon/os/contracts/apps/AragonApp.sol";
import "@aragon/os/contracts/lib/math/SafeMath.sol";
import "@aragon/os/contracts/lib/token/ERC20.sol";


contract Member is AragonApp {

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
}