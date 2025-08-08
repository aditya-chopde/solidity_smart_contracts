// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract CrowdFundingPlatform{
    // Structs
    struct BackersList{
        address donateBy;
        uint256 amount;
    }

    struct Campaign{
        address _creator;
        uint256 _goal;
        uint256 _deadline;
        uint256 _amtRaised;
        bool isCompleted;
        BackersList[] backers;
    }

    // State Variables
    Campaign[] public totalCampaign;    

    // Events 
    event CampaignCreated(uint256 campaignId, address _creator, uint256 _goal, uint256 _deadline);
    event EthDonated(address _from, uint256 campaignId, uint256 amt);
    event Refund();
    event Payout();

    // Functions
    // Create a Campaign 
    function createCampaign(uint256 _goal, uint256 _deadline) public {
        totalCampaign.push(); // Push an empty campaingn
        uint256 campaignId = totalCampaign.length - 1;

        // Filling values in the empty campaign
        Campaign storage newCampaign = totalCampaign[campaignId];
        newCampaign._creator = msg.sender;
        newCampaign._deadline = _deadline;
        newCampaign._goal = _goal;
        newCampaign._amtRaised = 0;
        newCampaign.isCompleted = false;

        emit CampaignCreated(campaignId, msg.sender, _goal, _deadline);
    } 

    // donate eth to campaign 
    function donate(uint256 campaignId) external payable {
        uint256 _amt = msg.value / 1 ether;

        require(_amt>0, "Amount must be greater than 0");
        require(campaignId<totalCampaign.length, "Invalid Campaign Id");
        require(totalCampaign[campaignId]._deadline >= block.timestamp, "Deadline Passed");

        totalCampaign[campaignId].backers.push(BackersList(msg.sender, _amt));
        totalCampaign[campaignId]._amtRaised += _amt;

        emit EthDonated(msg.sender, campaignId, _amt);
    }

    // refund if goal is not reached and deadline doesn't meet
    function refund(uint256 campaignId) external payable{
        Campaign storage getCampaign = totalCampaign[campaignId];
        require(getCampaign._deadline >= block.timestamp && getCampaign._amtRaised < getCampaign._goal, "Cannot Refund");

        getCampaign.isCompleted = true;
        uint256 len = getCampaign.backers.length;

        for(uint256 i=0; i<len; i++){
            BackersList storage getBackers = getCampaign.backers[i];

            payable(getBackers.donateBy).transfer(getBackers.amount);
        }

        emit Refund();
    }

    // payout
    function getFundsToCreator(uint256 _id) external payable{
        Campaign storage getCampaign = totalCampaign[_id];
        require(getCampaign._creator == msg.sender, "Only campaign creator can get the payout");
        require(getCampaign._deadline <= block.timestamp, "Campaign is Active");

        payable(msg.sender).transfer(getCampaign._amtRaised);
        getCampaign.isCompleted = true;

        emit Payout();
    }

    // get campaign details
    function getCampaignDetails(uint256 campaignId) public view returns(Campaign memory){
        return totalCampaign[campaignId];
    }
}