// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

import "./Pool.sol";

contract Coin {
    

    struct Info {
        address p_hash;
        uint256 time;
        uint256 tax;
        bool winner_state;
    }
    Info []  public players;



    Pool   pool = new Pool();

    function random() public view returns (uint) {
        // return  uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % 100;

        uint randNonce = 256;
        uint random = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))) % 100;
        uint random2 = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, random))) % 100;
        return random2;
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
       require(pool.getBalance()>0,"Pool is empty!");
       require(pool.getBalance()/50>msg.value,"Your bet is too big!");
       require(msg.value>0,"Your bet should be more than 0!");
        if(shake()==coinState) {
             pool.pay(msg.value,payable(msg.sender));
            players.push(Info(tx.origin,block.timestamp,msg.value*2,true));
            return true;
        }
        else
        {
            payable(address(pool)).transfer(msg.value);
            players.push(Info(tx.origin,block.timestamp,msg.value,false));
            return false;
        } 
    }

      function getBalance() public view returns(uint256){
        return pool.getBalance();
    }
    
    function getPlayersCount() public view returns(uint count) {
        return players.length;
    }
    
    function payPoolContract() public payable {
        require(msg.value>0,"Transfer bet should be more than 0!");
         payable(address(pool)).transfer(msg.value);
    }
}
