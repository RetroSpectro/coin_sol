// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./Pool.sol";

contract Coin {
    

    struct Info {
        address payable player;
        uint256 time;
        uint256 tax;
        bool winner_state;
    }
    Info []  public players;



    Pool   pool = new Pool();

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
        if(pool.getBalance()!=0&&shake()==coinState) {
            require(pool.getBalance()/50>msg.value,"Your bet is too big!");
            pool.pay(msg.value,payable(msg.sender));

            players.push(Info(payable(msg.sender),block.timestamp,msg.value*2,true));
            return true;
        }
        else
        {
            payable(address(pool)).transfer(msg.value);
            players.push(Info(payable(msg.sender),block.timestamp,msg.value,false));
            return false;
        } 
    }

      function getBalance() public view returns(uint256){
        return pool.getBalance();
    }
    
    function getPlayersCount() public view returns(uint count) {
        return players.length;
    }

}
