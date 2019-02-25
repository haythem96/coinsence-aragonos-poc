const Kit = artifacts.require("Kit.sol");


contract('Kit', (accounts) => {

    let kit, receipt;

    it('it should deploy', async () => {
        kit = await Kit.new('0x5f6f7e8cc7346a11ca2def8f827b7a0b612c56a1');
        console.log(kit.address);
    });
    
    it('it should not revert on newInstance()', async () => {
        receipt = await kit.newInstance();
    });
    
})
