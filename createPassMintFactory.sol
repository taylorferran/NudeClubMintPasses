// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.16;


import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract createPassMintFactory { 

    mapping (string => address) passMapping;

    function create(string memory passName, address _owner, uint _numberOfPasses, uint _passPrice) public payable {

        createPassMint passMint = new createPassMint(passName, _owner, _numberOfPasses, _passPrice);
        passMapping[passName] = address(passMint);
    } 

    function viewPassMintAddress(string memory _passName) public view returns(address) {
        return passMapping[_passName];
    }
}

// TODO make inhereting erc712 work
contract createPassMint is ERC721Enumerable { 

    uint public numberOfPasses;
    uint public passPrice;
    address public owner;
    string public passName;
    uint passesMinted;

    constructor (string memory _passName, address _owner, uint _numberOfPasses, uint _passPrice) {
        numberOfPasses = _numberOfPasses;
        passPrice = _passPrice;
        owner = _owner;
        passName = _passName;
    }

    function mint() public payable {
        // Mint one creator pass     here and either 
        // 1. Send ether directly to the creator
        // 2. Hold ether in the contract and let the creator withdraw from it
        require(IERC721(address(this)).balanceOf(msg.sender) == 0, "Only one mint allowed per wallet");
		require(msg.value >= passPrice, "Not enough eth sent");
        require(numberOfPasses <= passesMinted, "All passes minted");
		passesMinted += 1;
		_safeMint(msg.sender, passesMinted);
    } 
}
