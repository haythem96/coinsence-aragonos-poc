const CommunityContract = artifacts.require("Community");

contract('Community', (accounts) => {
  var communityInstance;

  let coinsenceDeployer;
  let member1;
  let member2;
  let member3;
  let member4;
  let member5;

  before(async() => {
    coinsenceDeployer = accounts[1];
    member1 = accounts[2];
    member2 = accounts[3];
    member3 = accounts[4];
    member4 = accounts[5];
    member5 = accounts[6];

    communityInstance = await CommunityContract.new({from: coinsenceDeployer});
  });

  it("create new space", async() => {
    let name = "coinsence";
    let desc = "freedom4people";
    let owner = member1;
    let members = [member2,member3, member4];

    //create new space
    await communityInstance.createSpace(name, desc, owner, members, {from: owner});
    
    let spaceNumber = await communityInstance.spacesCount();
    //check spaces number
    assert.equal(spaceNumber.toNumber(), 1);
    //check spaces related to that owner
    let count = await communityInstance.getMemberSpacesCount(owner);
    assert.equal(count.toNumber(), 1);
  });

});
