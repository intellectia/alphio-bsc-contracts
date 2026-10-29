// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Test} from "forge-std/Test.sol";
import {AlphioCheckIn} from "../src/AlphioCheckIn.sol";

contract AlphioCheckInTest is Test {
    AlphioCheckIn internal checkIn;
    address internal user = makeAddr("user");

    event CheckedIn(address indexed user, uint256 indexed day, uint256 count);

    function setUp() public {
        vm.warp(1_793_232_000); // 2026-10-29 00:00 UTC
        checkIn = new AlphioCheckIn();
    }

    function test_checkIn_recordsAndEmits() public {
        uint256 day = block.timestamp / 1 days;
        vm.expectEmit(address(checkIn));
        emit CheckedIn(user, day, 1);
        vm.prank(user);
        checkIn.checkIn();

        assertEq(checkIn.lastCheckInDay(user), day);
        assertEq(checkIn.checkInCount(user), 1);
    }

    function test_checkIn_twiceSameDayReverts() public {
        vm.startPrank(user);
        checkIn.checkIn();
        vm.warp(block.timestamp + 1 days - 1);
        vm.expectRevert(AlphioCheckIn.AlreadyCheckedInToday.selector);
        checkIn.checkIn();
        vm.stopPrank();
    }

    function test_checkIn_nextDayCounts() public {
        vm.startPrank(user);
        checkIn.checkIn();
        vm.warp(block.timestamp + 1 days);
        checkIn.checkIn();
        vm.stopPrank();
        assertEq(checkIn.checkInCount(user), 2);
    }

    function test_rejectsPlainBnbTransfer() public {
        vm.deal(user, 1 ether);
        vm.prank(user);
        (bool ok,) = address(checkIn).call{value: 1 ether}("");
        assertFalse(ok);
        assertEq(address(checkIn).balance, 0);
    }

    function test_checkIn_rejectsValue() public {
        vm.deal(user, 1 ether);
        vm.prank(user);
        (bool ok,) = address(checkIn).call{value: 1}(abi.encodeCall(AlphioCheckIn.checkIn, ()));
        assertFalse(ok);
    }
}
