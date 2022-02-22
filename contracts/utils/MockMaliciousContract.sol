// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../Interfaces/ILosslessGovernance.sol";

contract MockMaliciousContract {

    ILssGovernance public losslessGovernance;
    address owner;
    
    constructor(address _losslessGovernance){

        owner = msg.sender;
        losslessGovernance = ILssGovernance(_losslessGovernance);

    }

    ///@notice This function calls the governace contract to retrieve compensation for being wrongly accused
    ///@dev This function can only be called by contract owner
    function retrieveCompensation() public
    {
        require(msg.sender == owner, "Only owner of malicious code can excute");
        losslessGovernance.retrieveCompensationContract();
    }

    function retrieveCompensationForEOA() public
    {
         losslessGovernance.retrieveCompensation();
    }

}