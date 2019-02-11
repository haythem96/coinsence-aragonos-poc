const Space = artifacts.require("Community");

const DAOFactory = artifacts.require('@aragon/os/contracts/factory/DAOFactory');
const EVMScriptRegistryFactory = artifacts.require('@aragon/os/contracts/factory/EVMScriptRegistryFactory');
const ACL = artifacts.require('@aragon/os/contracts/acl/ACL');
const Kernel = artifacts.require('@aragon/os/contracts/kernel/Kernel');

const { assertRevert } = require('@aragon/test-helpers/assertThrow');
const getBlockNumber = require('@aragon/test-helpers/blockNumber')(web3);
const timeTravel = require('@aragon/test-helpers/timeTravel')(web3);

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
    spaceBase = await Space.new();

    // Setup constants
    APP_MANAGER_ROLE = await kernelBase.APP_MANAGER_ROLE();
    MANAGER_ROLE = await votingBase.CREATE_VOTES_ROLE();
    MINT_ROLE = await votingBase.MODIFY_SUPPORT_ROLE();
  });

  describe("common tests", () => {
    
    beforeEach(async () => {
      await space.initialize(daoFact.address, "coinsence", []);
    });

    it('fails on reinitialization', async () => {
      return assertRevert(async () => {
        await space.initialize(daoFact.address, "coinsence", []);
      })
    })

    it('cannot initialize base app', async () => {
      const newVoting = await Voting.new()
      assert.isTrue(await newVoting.isPetrified())
      return assertRevert(async () => {
        await space.initialize(daoFact.address, "coinsence", []);
      })
    })

    it('checks it is forwarder', async () => {
        assert.isTrue(await space.isForwarder())
    })
  });

});
