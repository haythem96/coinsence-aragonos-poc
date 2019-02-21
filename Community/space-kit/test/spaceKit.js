require('dotenv').config();

const SpaceKit = artifacts.require("SpaceKit.sol");
const ACL = artifacts.require('@aragon/os/contracts/acl/ACL');
const Kernel = artifacts.require('@aragon/os/contracts/kernel/Kernel');
const namehash = require('eth-ens-namehash').hash;
const ens = require('eth-ens-namehash').normalize;
const keccak256 = require('keccak256');

const { assertRevert } = require('@aragon/test-helpers/assertThrow');
const getBlockNumber = require('@aragon/test-helpers/blockNumber')(web3);
const timeTravel = require('@aragon/test-helpers/timeTravel')(web3);

const getContract = name => artifacts.require(name);

const ZERO_ADDR = '0x0000000000000000000000000000000000000000';

contract('Space kit', (accounts) => {

    let spaceKit, dao, appProxy;

    const root = accounts[0];

    before(async() => {
        spaceKit = new SpaceKit(process.env.ensAddr, { from: root });
    });

    describe("init kit", async() => {
        
        it("init", async() => {
            assert.notEqual(spaceKit, undefined);
        }); 

        it("deploy new space app instance", async() => {
            let appId = namehash("coinsence-aragon");
            let roles = [
                keccak256("MANAGER_ROLE")
            ];
            dao, appProxy = await spaceKit.newInstance(
                appId,
                roles,
                accounts[1],
                0x0,
                { from: root }
            );
        });
    });
});