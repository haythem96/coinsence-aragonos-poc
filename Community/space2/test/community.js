const Space = artifacts.require("Community.sol");

const ACL = artifacts.require("@aragon/os/contracts/acl/ACL");
const Kernel = artifacts.require("@aragon/os/contracts/kernel/Kernel");
/*
const DAOFactory = artifacts.require('@aragon/os/contracts/factory/DAOFactory');

const namehash = require('eth-ens-namehash').hash;
const keccak256 = require('keccak256');

const { assertRevert } = require('@aragon/test-helpers/assertThrow');
const getBlockNumber = require('@aragon/test-helpers/blockNumber')(web3);
const timeTravel = require('@aragon/test-helpers/timeTravel')(web3);
*/

const getContract = name => artifacts.require(name);

const ZERO_ADDR = '0x0000000000000000000000000000000000000000';

contract('Space app', (accounts) => {
  let kernel, acl, space;

  const root = accounts[0];
  const member1 = accounts[1];

  
  before(async() => {
    space = await Space.initialize("coinsence", [], { from: root });
    kernel = Kernel.at(await space.kernel());
    acl = ACL.at(await kernel.acl());
  });  
  
  describe("Space app", async() => {

    it('check initialized app', async() => {
      assert.notEqual(space, undefined);
      console.log(space.address);
      console.log(kernel);
    });

  });
  /*
  describe("Owner default space permissions", async() => {

    it('check owner is space manager', async() => {
      let spaceManagerPermission = await space.acl().hasPermission(root, space.address, await space.MANAGER_ROLE());
      assert.equal(spaceManagerPermission, true);
    });
    
    it('check owner is token issuer', async() => {
      let tokenIssuerPermission = await acl.hasPermission(root, space.address, await space.ISSUE_TOKEN_ROLE());
      assert.equal(tokenIssuerPermission, true);
    });
  });
  
  describe("Space members management", async () => {

    it("should revert when adding a member from an address that does not have manager permission", async() => {
      return assertRevert(async () => {
        await space.addMember(accounts[2], { from: member1 })
        'address does not have permission to add member'
      })
    });

    it("should revert when adding a member address same as `msg.sender`", async() => {
      return assertRevert(async () => {
        await space.addMember(root, { from: root })
        'member address should be different from msg.sender'
      })
    });

    it("should revert when adding a member with address(0)", async() => {
      return assertRevert(async () => {
        await space.addMember(ZERO_ADDR, { from: root })
        'member address should be different from msg.sender'
      })
    });

    it("add new member", async() => {
      await space.addMember(member1, { from: root });
      assert.equal(await space.isMember(member1), true);
    });
  });

  describe("Space members permissions management", async() => {
    
    //TODO: permissions should be directly assigned in the solidity function
    before(async() => {
      await acl.grantPermission(
        member1,
        space.address,
        await space.MANAGER_ROLE(),
        { from: root }
      )
    });

    it("Grant space manager permission to new member from space owner", async() => {
      let memberSpaceManagerPermission = await acl.hasPermission(member1, space.address, await space.MANAGER_ROLE());
      assert.equal(memberSpaceManagerPermission, true);
      let ownerSpaceManagerPermission = await acl.hasPermission(root, space.address, await space.MANAGER_ROLE());
      assert.equal(ownerSpaceManagerPermission, true);
    });

  });
  */

});