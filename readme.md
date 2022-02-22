# Lossless V3

In-depth documentation on Lossless V3 is available at [lossless.cash](https://lossless-cash.gitbook.io/lossless/).

## Install Dependencies

`npm i`

## Run Tests

`npm test`

<br>

***

## Challenge on Lossless Protocol 

***
<br>
<br>

>**_REQUIREMENT:_**

```
Lossless Core Protocol user is able to report a transaction that seems to be malicious. As soon as the report gets generated, the reported
address gets blacklisted until the report is solved. This means that no transfers can be done by the address effectively freezing its funds.
While the report is open, a voting process takes places where three different teams cast their votes on it to determine its validity. After the
majority votes, the report can be solved by anyone and it will be closed triggering some more logic. 

Right now this could go three ways:

1. The report can be deemed as valid so the funds are returned to the rightful owner.

2. The report can be deemed as invalid which will trigger a compensation for the reported address.

3. The report can expire (with or without some votes casted) which will also trigger a compensation.

For this task you will focus on the compensation process of an invalid reported address as at the moment only wallets are able to retrieve said
compensation. But what happens if a Smart Contract gets reported erroneously?
Your objective is to create a new function that will allow Smart Contracts to claim the compensation for being wrongly reported. This new logic
should be added to the Lossless Governance Smart Contract and should allow only Smart Contracts to claim the reimbursement. You will also
need to write some tests to verify the logic is working correctly in the payoutRefund.js test file.

The LosslessV3 repository should be cloned and worked on, after that you can submit your solution by uploading it to your personal GitHub.
In order to complete the task you will need to get familiar with the reporting, voting and solving process that takes place among the Lossless
Reporting, Lossless Controller and Lossless Governance Smart Contracts. Also take into consideration that the Lossless code will only be able to
interact with tokens using the LERC20 standard which can also be found among the contracts on the repository.

Any questions are welcomed and encouraged!
```
<br>

# Solution 

## Description :


The solution from my end is quite simple, since the implementation of retrieving funds for an EOA and Contract Account are more similar than dissimilar. This is the method to retrieve funds for an EOA in  `LosslessGovernance.sol` :
<br>
<br>

![ Image of retrieveCompensation function ](https://i.imgur.com/fRbXdVY.png)

An implementation for `retrieveCompensationContract` function will look like this: <br><br> 

![Image of retrieveCompensation function ](https://i.imgur.com/ZWYxFcD.png)

<br> <br> 

The difference here is that a new `require` function was introduced which limits access to only contracts. Like I said the previous function and this are more similar than not, there is 90% code duplication from the former to the later, we can mitigate this by moving the core/similarity to a new private function and allow both functions reuse. So a third function will go like this: <br><br>
![new private function](https://i.imgur.com/jCSPrs3.png)
<br> <br> 
This new function is stripped off all modifiers as those will be housed by the public functions now: 
<br> <br> 
![retrieve for EOA address](https://i.imgur.com/3kH8pYA.png)
<br>
<br>
![retrieve for contract address](https://i.imgur.com/t76f6Xu.png)

<br> <br> 
Both functions now contain the missing modifier, and the private function itself. you can also notice the new `require` function also included in the function for EOA retrieving compensation. This limits the function to only EOAs only. The new public function is also included in the LosslessGovernance contract interface; `ILssGovernance`. 

### More: 
I also took the liberty to update the method body for retrieving compensations to conform to opinionated industry standards, I will try my best to explain the standards below: 

1. Checks - Effects - Interactions: This simply says you should perform *validation* first, then *effect* the change of state that is expected on success execution of the current transaction, then *interact* which in our context is making a transfer.  The implementation of this on the current method would result to this: <br> <br>

![modified function](https://i.imgur.com/H7ilLG8.png) <br> <br> 

<em>Note:</em> It is worth noting that the actual transfer of funds which is performed on `LosslessReport.sol` is achieved using `transfer` function, `transfer` uses a hardcoded gas of  2300 gas. Which frustrates known attacks like reentrance, since reentrance mostly depends on the contract allowing user to forward its desired amount of gas without any limitation on the contract's end. 

### Testing: 