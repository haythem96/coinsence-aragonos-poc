pragma solidity ^0.4.24;

import "@aragon/os/contracts/apps/AragonApp.sol";
import "@aragon/os/contracts/lib/math/SafeMath.sol";


contract Community is AragonApp {

    struct Space {
        bytes32 id;
        bytes32 coin;
        string name;
        string description;
        address[] members;

    }

    function initialize() public onlyInit {
        initialized();
    }

}