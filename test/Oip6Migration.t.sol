pragma solidity 0.8.19;

import {Oip6Migration} from "../contracts/Oip6Migration.sol";
import {Test} from "forge-std/Test.sol";
import {MockERC20} from "../contracts/test/MockERC20.sol";

contract Oip6MigrationTest is Test {
    Oip6Migration migration;
    MockERC20 public oldToken;
    MockERC20 public newToken;
    address public deployer;
    address public user1;
    address public user2;

    function setUp() public {
        deployer = vm.addr(1);
        user1 = vm.addr(2);
        user2 = vm.addr(3);

        vm.startPrank(deployer);

        oldToken = new MockERC20(1_000_000, "OLD");
        newToken = new MockERC20(1_000_000, "NEW");
        vm.label(address(oldToken), "oldToken");
        vm.label(address(newToken), "newToken");
        vm.label(user1, "user");

        oldToken.transfer(user1, 10_000);
        oldToken.transfer(user2, 100_000);

        migration = new Oip6Migration(address(oldToken), address(newToken));

        vm.stopPrank();
    }

    function test_noNewTokens() public {
        vm.startPrank(user1);
        oldToken.approve(address(migration), 10_000);
        vm.expectRevert(abi.encodeWithSelector(Oip6Migration.NotEnoughNewTokens.selector, 10_000));
        migration.swap(10_000);
        vm.stopPrank();
        assertEq(oldToken.balanceOf(address(migration)), 0);
    }

    function test_notEnoughNewTokens() public {
        vm.prank(deployer);
        newToken.transfer(address(migration), 1);
        vm.startPrank(user1);
        oldToken.approve(address(migration), 10_000);
        vm.expectRevert(abi.encodeWithSelector(Oip6Migration.NotEnoughNewTokens.selector, 9_999));
        migration.swap(10_000);
        vm.stopPrank();
        assertEq(oldToken.balanceOf(address(migration)), 0);
    }

    function test_swap_full() public {
        vm.prank(deployer);
        newToken.transfer(address(migration), 100_000);
        vm.startPrank(user1);
        oldToken.approve(address(migration), 10_000);
        migration.swap(10_000);
        vm.stopPrank();
        assertEq(oldToken.balanceOf(user1), 0);
        assertEq(newToken.balanceOf(user1), 10_000);
        assertEq(oldToken.balanceOf(address(migration)), 10_000);
    }

    function test_swap_full_multiple_users() public {
        vm.prank(deployer);
        newToken.transfer(address(migration), 100_000);

        vm.startPrank(user1);
        oldToken.approve(address(migration), 10_000);
        migration.swap(10_000);
        vm.stopPrank();
        assertEq(oldToken.balanceOf(user1), 0);
        assertEq(newToken.balanceOf(user1), 10_000);

        vm.startPrank(user2);
        oldToken.approve(address(migration), 40_000);
        migration.swap(40_000);
        vm.stopPrank();
        assertEq(oldToken.balanceOf(user2), 60_000);
        assertEq(newToken.balanceOf(user2), 40_000);
        assertEq(oldToken.balanceOf(address(migration)), 50_000);
    }

    function test_swap_full_multiple_swaps() public {
        vm.prank(deployer);
        newToken.transfer(address(migration), 100_000);
        vm.startPrank(user1);
        oldToken.approve(address(migration), 10_000);
        migration.swap(4_000);
        assertEq(oldToken.balanceOf(user1), 6_000);
        assertEq(newToken.balanceOf(user1), 4_000);
        migration.swap(6_000);
        assertEq(oldToken.balanceOf(user1), 0);
        assertEq(newToken.balanceOf(user1), 10_000);
        vm.stopPrank();
        assertEq(oldToken.balanceOf(address(migration)), 10_000);
    }

    function test_swap_full_multiple_swaps_amount_exceeds() public {
        vm.prank(deployer);
        newToken.transfer(address(migration), 100_000);
        vm.startPrank(user1);
        oldToken.approve(address(migration), 1_000_000);
        migration.swap(4_000);
        assertEq(oldToken.balanceOf(user1), 6_000);
        assertEq(newToken.balanceOf(user1), 4_000);
        vm.expectRevert("ERC20: transfer amount exceeds balance");
        migration.swap(6_001);
        vm.stopPrank();
        assertEq(oldToken.balanceOf(address(migration)), 4_000);
    }

    function test_swap_partial() public {
        vm.prank(deployer);
        newToken.transfer(address(migration), 100_000);
        vm.startPrank(user1);
        oldToken.approve(address(migration), 6_000);
        migration.swap(3_000);
        vm.stopPrank();
        assertEq(oldToken.balanceOf(user1), 7_000);
        assertEq(newToken.balanceOf(user1), 3_000);
        assertEq(oldToken.balanceOf(address(migration)), 3_000);
    }

    function test_swap_partial_multiple_swaps() public {
        vm.prank(deployer);
        newToken.transfer(address(migration), 100_000);
        vm.startPrank(user1);
        oldToken.approve(address(migration), 6_000);
        migration.swap(3_000);
        assertEq(oldToken.balanceOf(user1), 7_000);
        assertEq(newToken.balanceOf(user1), 3_000);
        migration.swap(2_000);
        assertEq(oldToken.balanceOf(user1), 5_000);
        assertEq(newToken.balanceOf(user1), 5_000);
        vm.stopPrank();
        assertEq(oldToken.balanceOf(address(migration)), 5_000);
    }

    // function testFail_Subtract43() public {
    //     testNumber -= 43;
    // }
}

// TODO
// Make sure names of tokens are correct
// Make sure decimals are equal
