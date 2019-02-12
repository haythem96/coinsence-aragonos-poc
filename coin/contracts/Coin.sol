pragma solidity ^0.4.24;

import "../node_modules/@aragon/os/contracts/apps/AragonApp.sol";
import "../node_modules/@aragon/os/contracts/factory/DAOFactory.sol";
import "../node_modules/@aragon/os/contracts/common/EtherTokenConstant.sol";
import "../node_modules/@aragon/os/contracts/lib/token/ERC20.sol";

import "../node_modules/@aragon/os/contracts/lib/math/SafeMath.sol";

contract Coin is EtherTokenConstant, DAOFactory, AragonApp {
    
    using SafeMath for uint256;

    bytes32 public constant ISSUE_ROLE = keccak256("ISSUE_ROLE");
    bytes32 public constant MINT_ROLE = keccak256("MINT_ROLE");
    bytes32 public constant TRANSFER_ROLE = keccak256("TRANSFER_ROLE");
    bytes32 public constant ASSIGN_ROLE = keccak256("ASSIGN_ROLE");

}