// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.24;

contract CrowdFunding {

  struct CampaignStruc {
    string title;
    string description;
    address payable benefactor;
    uint256 goal;
    uint256 deadline;
    uint amountRaised;
    bool statusOfCampaign;
  }

  mapping(uint256 => CampaignStruc) public fundingCampaignObject;
  uint256 public nounce;

  event logInfoForCampaignCreated(uint256 campaignID, string title, string description, address benefactor, uint256 goal, uint256 deadline);
  event logInfoForConfirmationOfDonationReceived(uint256 campaignId, address whoDonates, uint256 amountDonated);
  event logInfoUponConformationThatCampaignEnded(uint256 campaignId, uint amountRaised, bool isTheGoalMetForCampaign);


  function createCampaign(string memory _title, string memory _description, address payable _benefactor, uint256 _goal, uint256 duration) public {
    require(_goal > 0, "Stop Joking Mate!! You need to have solid goals");
    uint _deadline = block.timestamp + duration;

    fundingCampaignObject[nounce] = CampaignStruc({
      title: _title,
      description: _description,
      benefactor: _benefactor,
      goal: _goal,
      deadline: _deadline,
      amountRaised: 0,
      statusOfCampaign: false
    });

    emit logInfoForCampaignCreated(nounce, _title, _description, _benefactor, _goal, _deadline);
    nounce++;
  }

  function donateToCampaign(uint256 campaignId) public payable {
    CampaignStruc storage donateTo = fundingCampaignObject[campaignId];
    require(block.timestamp < donateTo.deadline, "A little sleep, a little slumber!! Unfortunately, donation can't be accepted because funding Campaign has ended!!!");

    if(donateTo.statusOfCampaign) {
      revert("There's always a room for next time!! Your Money is Important to the community. But for now, This Campaign has ended!!!");
    }

    donateTo.amountRaised += msg.value;
    emit logInfoForConfirmationOfDonationReceived(campaignId, msg.sender, msg.value);
  }

  function endCampaign(uint256 campaignId) public {
    CampaignStruc storage endCampaignFor = fundingCampaignObject[campaignId];
    require(block.timestamp >= endCampaignFor.deadline, "Early bird is what you are. This campaign is still on and your money can do much good than harm. Go ahead to donate!!!");
    if (endCampaignFor.statusOfCampaign) {
      revert("Aww!! This funding Campaign has ended");
    }
    endCampaignFor.statusOfCampaign = true;
    endCampaignFor.benefactor.transfer(endCampaignFor.amountRaised);
    emit logInfoUponConformationThatCampaignEnded(campaignId, endCampaignFor.amountRaised, endCampaignFor.amountRaised >= endCampaignFor.goal);
  }
  
}