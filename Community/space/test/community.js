const Space = artifacts.require("Community.sol");
const DAOFactory = artifacts.require('@aragon/os/contracts/factory/DAOFactory');
const EVMScriptRegistryFactory = artifacts.require('@aragon/os/contracts/factory/EVMScriptRegistryFactory');
const ACL = artifacts.require('@aragon/os/contracts/acl/ACL');
const Kernel = artifacts.require('@aragon/os/contracts/kernel/Kernel');

const namehash = require('eth-ens-namehash').hash;
const keccak256 = require('keccak256');

const { assertRevert } = require('@aragon/test-helpers/assertThrow');
const getBlockNumber = require('@aragon/test-helpers/blockNumber')(web3);
const timeTravel = require('@aragon/test-helpers/timeTravel')(web3);

const getContract = name => artifacts.require(name);

contract('Space App', (accounts) => {
  let spaceBase, daoFact, space;

  let APP_MANAGER_ROLE;
  let MANAGER_ROLE, MINT_ROLE;

  const root = accounts[0];

  let coinsenceDeployer;
  let member1;
  let member2;
  let member3;
  let member4;
  let member5;

  before(async() => {

    const kernelBase = await getContract('Kernel').new(true);
    const aclBase = await getContract('ACL').new();
    const regFact = await EVMScriptRegistryFactory.new();
    daoFact = await DAOFactory.new(kernelBase.address, aclBase.address, regFact.address);    
  });

  describe("common tests", () => {
    
    beforeEach(async () => {
      spaceBase = await Space.new(daoFact.address, namehash('coinsence-aragon.aragonpm.eth'), "coinsence", []);
    });

    it('fails on reinitialization', async () => {
      return assertRevert(async () => {
        await spaceBase.initialize();
      })
    })

    it('checks it is forwarder', async () => {
        assert.isTrue(await spaceBase.isForwarder())
    });

    it('create new instance with role assigned to owner', async() => {
      let roles = [
        keccak256("MANAGER_ROLE"),
        keccak256("MINT_ROLE") 
      ]

      //space = await spaceBase.newInstance(namehash('coinsence-aragon.aragonpm.eth'), roles, accounts[0], 0x0);
      await space.initialize();
    });

  });

});
