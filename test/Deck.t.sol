// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

contract DeckTest is Test {
    Deck public deck;

    function setUp() public {
        deck = Deck(HuffDeployer.deploy("Deck"));
    }

    function testNewDeck() public {
      deck.newDeck(12, 13);
    }

    function testNewDeckInvalid() public {
      vm.expectRevert(abi.encodeWithSelector(Deck.InvalidArgument.selector));
      deck.newDeck(0, 13);
    }

    function testChangeAddressUninitialised() public {
      vm.expectRevert(abi.encodeWithSelector(Deck.Unauthorised.selector));
      deck.changeAddress(1, 1, address(this));
    }

    function testChangeDealer() public {
      deck.newDeck(1, 1);
      deck.changeDealer(0, address(0x0));
    }

    function testChangeAddress() public {
      deck.newDeck(1, 1);
      deck.changeAddress(0, 0, address(0x0));
    }

    function testChangeDealerTwice() public {
      deck.newDeck(1, 1);
      deck.changeDealer(0, address(0x0));
      vm.expectRevert(abi.encodeWithSelector(Deck.Unauthorised.selector));
      deck.changeDealer(0, address(this));
    }

    function testChangeAddressTwice() public {
      deck.newDeck(1, 1);
      deck.changeAddress(0, 0, address(0x0));
      vm.expectRevert(abi.encodeWithSelector(Deck.Unauthorised.selector));
      deck.changeAddress(0, 0, address(this));
    }
}

interface Deck {
	error InvalidArgument();
	error Unauthorised();
	function changeAddress(uint256, uint256, address) external;
	function changeDealer(uint256, address) external;
	function newDeck(uint256, uint256) external;
}
