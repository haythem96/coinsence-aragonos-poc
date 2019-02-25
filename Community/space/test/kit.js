/* eslint-disable no-undef */
const Kernel = artifacts.require("@aragon/os/contracts/kernel/Kernel.sol");
const ACL = artifacts.require("@aragon/core/contracts/acl/ACL.sol");
const Kit = artifacts.require("Kit.sol");
const Community = artifacts.require("Community.sol");

const namehash = require('eth-ens-namehash').hash;
const ADDR_NULL = '0x0000000000000000000000000000000000000000';

//const { ADDR_NULL, ADDR_ANY } = require('@pando/helpers/address')
const chai = require('chai')
/* eslint-disable no-unused-vars */
const should = chai.should()
/* eslint-enable no-unused-vars */

const arapp = require('../arapp.json')
const ENS_ADDRESS = arapp.environments.default.registry

contract('DAO bare kit', (accounts) => {
    let kit;
    let address;
    let apps;
    let kernel;
    let acl;
    let space;

    before(async () => {
        kit = await Kit.new(ENS_ADDRESS, { from: accounts[0] });
    })
  
    describe("New DAO instance", () => {
        it("kit should be defined", async() => {
            assert.notEqual(kit, undefined);
            console.log(kit.address);
        });

        it('it should deploy DAO', async () => {
            const receipt = await kit.newInstance({ from: accounts[0] });

            address = receipt.logs.filter(l => l.event === 'DeployInstance')[0].args.dao
            apps = receipt.logs
                .filter(l => l.event === 'InstalledApp')
                .map(event => {
                    return { id: event.args.appId, proxy: event.args.appProxy }
                })

            address.should.not.equal(ADDR_NULL);
        });

        it('it should install apps', async () => {
            apps[0].id.should.equal(namehash('coinsence-aragon.aragonpm.eth'))

            kernel = await Kernel.at(address);
            acl = await ACL.at(await kernel.acl());
            space = await Community.at(apps[0].proxy);
        });

        it('it should initialize apps', async () => {
            ;(await Promise.all([
                space.hasInitialized(),
            ])).should.deep.equal([true])
        });

        it('it should set permissions', async () => {
            ;(await Promise.all([
                //kernel.hasPermission(space.address, kernel.address, await kernel.APP_MANAGER_ROLE(), '0x0'),
                //kernel.hasPermission(space.address, acl.address, await acl.CREATE_PERMISSIONS_ROLE(), '0x0'),
                kernel.hasPermission(accounts[0], space.address, await space.MANAGER_ROLE(), '0x0'),
                kernel.hasPermission(accounts[0], space.address, await space.ISSUE_TOKEN_ROLE(), '0x0'),
            ])).should.deep.equal([true, true])
        });
    });
})
