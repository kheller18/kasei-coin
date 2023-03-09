pragma solidity ^0.5.0;

import "./KaseiCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";


// crowdsale contract
contract KaseiCoinCrowdsale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundablePostDeliveryCrowdsale {

    // crowdsale constructor
    constructor(
        uint rate,
        address payable wallet,
        KaseiCoin token,
        uint goal, // crowdsale goal
        uint open, // crowdsale opening time
        uint close // crowdsale closing
    ) public 
        Crowdsale(rate, wallet, token)
        CappedCrowdsale(goal)
        TimedCrowdsale(open, close)
        RefundableCrowdsale(goal)
    {
        // constructor can stay empty
    }
}


contract KaseiCoinCrowdsaleDeployer {
    // Two addresses, one for the token address and one for the crowdsale address
    address public kasei_token_address;
    address public kasei_crowdsale_address;

    // deployer constructor
    constructor(
       string memory name,
       string memory symbol,
       address payable wallet,
       uint goal
    ) public {
        // Creates a new instance of the KaseiCoin contract
        KaseiCoin token = new KaseiCoin(name, symbol, 0);

        // Assigns the token contract’s address to the `kasei_token_address` variable
        kasei_token_address = address(token);

        // Creates a new instance of the `KaseiCoinCrowdsale` contract
        KaseiCoinCrowdsale kasei_crowdsale = new KaseiCoinCrowdsale(1, wallet, token, goal, now, now + 24 weeks);

        // Aassigns the `KaseiCoinCrowdsale` contract’s address to the `kasei_crowdsale_address` variable
        kasei_crowdsale_address = address(kasei_crowdsale);

        // Sets the `KaseiCoinCrowdsale` contract as a minter
        token.addMinter(kasei_crowdsale_address);

        // `KaseiCoinCrowdsaleDeployer` renounces its minter role
        token.renounceMinter();
    }
}
