// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

/// @title AlphioCheckIn
/// @notice Alphio's on-chain presence on BNB Smart Chain (submitted to
/// DappBay). Any address may check in once per UTC day; each check-in
/// emits `CheckedIn` so activity is indexable.
///
/// Zero-trust: no owner, no admin, no upgradeability, no payable entry
/// points (plain BNB transfers revert), no external calls. The contract
/// never holds funds and the deployer keeps no privileges after deploy.
contract AlphioCheckIn {
    string public constant NAME = "Alphio";
    string public constant WEBSITE = "https://alphio.ai";

    /// UTC day index (`block.timestamp / 1 days`) of the caller's last check-in; 0 = never.
    mapping(address => uint256) public lastCheckInDay;
    mapping(address => uint256) public checkInCount;

    event CheckedIn(address indexed user, uint256 indexed day, uint256 count);

    error AlreadyCheckedInToday();

    function checkIn() external {
        uint256 day = block.timestamp / 1 days;
        if (lastCheckInDay[msg.sender] == day) revert AlreadyCheckedInToday();

        lastCheckInDay[msg.sender] = day;
        uint256 count = ++checkInCount[msg.sender];
        emit CheckedIn(msg.sender, day, count);
    }
}
