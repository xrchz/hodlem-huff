// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

contract SimpleStoreTest is Test {
    /// @dev Address of the SimpleStore contract.
    SimpleStore public simpleStore;
    Deck public deck;

    /// @dev Setup the testing environment.
    function setUp() public {
        simpleStore = SimpleStore(HuffDeployer.deploy("SimpleStore"));
        deck = Deck(HuffDeployer.deploy("Deck"));
    }

    /// @dev Ensure that you can set and get the value.
    function testSetAndGetValue(uint256 value) public {
        simpleStore.setValue(value);
        console.log(value);
        console.log(simpleStore.getValue());
        assertEq(value, simpleStore.getValue());
    }

    function testNewDeck() public {
      deck.newDeck(12, 13);
    }

    function testNewDeckInvalid() public {
      vm.expectRevert(abi.encodeWithSelector(Deck.InvalidArgument.selector));
      deck.newDeck(0, 13);
    }

    function testChangeAddress() public {
      vm.expectRevert();
      deck.changeAddress(1, 1, address(this));
    }
}

interface SimpleStore {
    function setValue(uint256) external;
    function getValue() external returns (uint256);
}

interface Deck {
	error InvalidArgument();
	error Unauthorised();
	function changeAddress(uint256, uint256, address) external;
	function changeDealer(uint256, address) external;
	function newDeck(uint256, uint256) external;
}
