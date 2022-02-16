// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./Pool.sol";

contract Coin {

    struct Player {
        uint256 time;
        address payable player_address;
        uint256 tax;
        bool winner_state;
    }

    Player[] public players;

    Pool pool;

    constructor(){
    pool = new Pool();
    }


    function random() public view returns (uint) {
        return  uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % 100;
    }

    function shake() internal view returns(bool){
        if(this.random()>=50)
        {
            return true;
        }
        else{
            return false;
        }
    }


    function play(bool coinState) public payable returns(bool){
        require(pool.getBalance()/50>msg.value,"Your bet is too big!");
        

        if(pool.getBalance()!=0&&shake()==coinState) {
            pool.pay(msg.value,payable(msg.sender));
            players.push(Player(block.timestamp,payable(msg.sender),msg.value*2,true));
            return true;
        }
        else
        {
            pool.pay(msg.value,payable(address(pool)));
            players.push(Player(block.timestamp,payable(msg.sender),msg.value*2,true));
            return false;
        } 
    }

  
}