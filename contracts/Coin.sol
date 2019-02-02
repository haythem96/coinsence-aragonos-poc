pragma solidity ^0.4.24;

import "@aragon/os/contracts/apps/AragonApp.sol";
import "@aragon/os/contracts/common/EtherTokenConstant.sol";
import "@aragon/os/contracts/lib/token/ERC20.sol";
import "@aragon/os/contracts/lib/math/SafeMath.sol";

import "./lib/StandardCoin.sol";


contract Coin is EtherTokenConstant, AragonApp {
    
    using SafeMath for uint256;

    bytes32 public constant ISSUE_ROLE = keccak256("ISSUE_ROLE");
    bytes32 public constant MINT_ROLE = keccak256("MINT_ROLE");
    bytes32 public constant TRANSFER_ROLE = keccak256("TRANSFER_ROLE");
    bytes32 public constant ASSIGN_ROLE = keccak256("ASSIGN_ROLE");

    ERC20 public token;

    struct Token {
        address contractAddress;
        string space;
        uint256 amount;
    }

    //number of tokens
    uint256 tokensCount;

    mapping(bytes32 => address) public coins;

    function issueCoin(
        bytes32 _spaceId, 
        string _name, 
        string _symbol, 
        uint8 _decimals, 
        uint256 _supply
    ) internal isInitialized {
        StandardCoin coinAddress = new StandardCoin(_name, _symbol, _decimals, _supply, msg.sender);
        coins[_spaceId] = coinAddress;
    }

}