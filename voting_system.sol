// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract VoteApp{

    struct Candidate{
        string name;
        uint256 voteCount;
    }

    // variables
    Candidate[] public candidates;
    bool public isVotingStarted;
    bool public isVotingEnded;
    address admin = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    mapping(address => bool) public isDoneVoting;

    // events
    event candidateAdded(string _name);
    event doneVoting();
    event votingStarted();
    event votingEnded();

    // modifiers
    modifier onlyAdmin(){
        require(msg.sender == admin, "Only Admins can add Candidated");
        _;
    }

    modifier whenVotingActive(){
        require(!isVotingEnded && isVotingStarted, "Voting is not active");
        _;
    }

    function getCandidated() public view returns(Candidate[] memory){
        return candidates;
    }

    function addCandidate(string memory _name) public onlyAdmin{
        candidates.push(Candidate(_name, 0));
        emit candidateAdded(_name);
    }

    function startVoting() public{
        require(!isVotingStarted, "Voting Started Already");
        isVotingStarted = true;
        emit votingStarted();
    }

    function endVoting() public {
        require(isVotingStarted && !isVotingEnded, "Voting not Active");
        isVotingEnded = true;
        emit votingEnded();
    }

    function makeVote(uint256 _idx) public whenVotingActive{
        require(isVotingStarted && !isVotingEnded, "Voting not Active");
        require(!isDoneVoting[msg.sender], "Already Voted");
        require(_idx < candidates.length, "Invalid Candidate");

        candidates[_idx].voteCount += 1;
        isDoneVoting[msg.sender] = true;
        emit doneVoting();
    }

    function getWinner() public view returns(string memory, uint256){
        require(isVotingEnded, "Voting not Ended");
        uint256 maxVote = 0;
        uint256 winnerIdx = 0;

        for(uint256 i=0; i<candidates.length; i++){
            if(candidates[i].voteCount>maxVote){
                maxVote = candidates[i].voteCount;
                winnerIdx = i;
            }
        }

        return (candidates[winnerIdx].name, maxVote); 
    }
}