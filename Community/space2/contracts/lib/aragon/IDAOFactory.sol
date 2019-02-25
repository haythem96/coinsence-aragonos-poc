pragma solidity ^0.4.24;

import "./IKernelEnhanced.sol";

interface IDAOFactory {
    function newDAO(address _root) external returns (IKernelEnhanced);
}