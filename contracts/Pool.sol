// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;



contract Pool {

    receive() payable external{

    }
    
    function getBalance()  public view returns(uint256){
        return address(this).balance;
    }

    function pay(uint256 payment, address payable winner) public {
        winner.transfer(payment*2);
    }

  
}