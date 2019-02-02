pragma solidity ^0.4.24;

import "@aragon/os/contracts/apps/AragonApp.sol";
import "@aragon/os/contracts/lib/math/SafeMath.sol";


contract Member is AragonApp {

    function initialize() public onlyInit {
        initialized();
    }
}