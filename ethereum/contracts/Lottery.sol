pragma solidity ^0.4.17;

contract Lottery {
  address public manager;
  address[] public players;

  function Lottery() public {
    manager = msg.sender;
  }

  function enter() public payable {
    // Minimum contribution each player has to make to enter to play
    // msg.value is the amount of money in wei. By putting in ether, .01 will automatically get converted into the
    // appropriate amount of wei
    require(msg.value > .01 ether);

    players.push(msg.sender);
  }

  function random() private view returns (uint) {
    return uint(keccak256(block.difficulty, now, players));
  }

  function pickWinner() public {
    require(msg.sender == manager);

    uint index = random() % players.length;
    //'this' is a ref to the instance of the current contract and balance is the amount of money the
    // current contract has available to it
    players[index].transfer(this.balance);

    // Reset contract state
    //[](0): dynamic array with an initial size of 0
    players = new address[](0);
  }

  function getPlayers() public view returns (address[]) {
    return players;
  }
}
