// SPDX-License-Identifier:MIT
pragma solidity ^0.8.9;

contract Voting {

    // Voter custom type
    // Candidate custom types
    // mapping of voters
    // array of candidates
    // give a voter right to vote
    // voter can delegate their vote
    // voters can vote directly
    // show winning candidate



    struct Voter {
        uint weight; // amount of votes added to candidate votted for, accumulated by delegation
        uint vote; // candidate id voting for
        bool status; // if 0 not votted, if 1 votted
        address delegate; // address you are delegating your vote to 
    }

    mapping(address => Voter) public voters;

    struct Candidate {
        string name;
        uint voteCount;
    }

    Candidate[] public candidates;

    address public chairPerson;

    constructor (string[] memory _candidateNames) {
        chairPerson = msg.sender;
        voters[chairPerson].weight = 1;

        for(uint i = 0; i < _candidateNames.length; i++) {
            require(_candidateNames.length > 0, "provide candidates");
            candidates.push(Candidate(_candidateNames[i], 0));
        }
    }

    function giveRightToVote(address _voter) external {
        require(msg.sender == chairPerson, "only chairperson gives right to vote");
        require(!voters[_voter].status, "Already votted");
        require(voters[_voter].weight == 0, "Right Given");

        voters[_voter].weight = 1;
    }

    function delegateVote(address to) external {
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "You have no right to vote");
        require(!sender.status, "Already Voted");

        // if the voter you are delegating to has already delegated their vote
        // by checking that the to address is no longer the default adress type of address(0)
        // we ensure that we get to the delgate they delegated to
        
        while(voters[to].delegate != address(0)) {
            to = voters[to].delegate;
            require(to != msg.sender, "you cannot delegate to yourself");
        }

        sender.status = true;
        sender.delegate = to;

        Voter storage _delegate = voters[to];

        // if delegate already voted
        // directly increase the candidate's voteCount they voted for
        // else just add the the delegates weight
        if(_delegate.status == true){
            candidates[_delegate.vote].voteCount += sender.weight;
        }else{
            _delegate.weight += sender.weight;
        }
        
    }

    function getDelegate () external view returns (address to){
        to = voters[msg.sender].delegate;
    }

    
    function vote (uint candidateId) public{
        Voter storage voter = voters[msg.sender];
        require(!voter.status, "Already Voted");
        require(voter.weight != 0, "Right not given");

        voter.status = true;
        voter.vote = candidateId;
        candidates[candidateId].voteCount += voter.weight;
    }
    

    function winningCandidate() public view returns(uint winningId)  {
        uint count = 0;
        for(uint i = 0; i < candidates.length; i++){
            uint _voteCount = candidates[i].voteCount;
            if (_voteCount > count) {
                count = _voteCount;
                winningId = i;
            }
        }
    }

    function winningCandidateName () public view returns (string memory _name){
        _name = candidates[winningCandidate()].name;
    }


}