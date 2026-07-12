// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title PipelineTelemetryRegistry
 * @dev On-chain directory mapping verified instruction hashes to optimized execution routes.
 */
contract PipelineTelemetryRegistry is Ownable {

    struct BytecodeProfile {
        bytes32 verificationHash;
        uint32 recommendedLanesCount;
        bool isProfileActive;
    }

    mapping(address => BytecodeProfile) public runtimeProfiles;
    address public engineeringManager;

    event ProfileRegistered(address indexed targetContract, bytes32 verificationHash, uint32 lanes);

    constructor() Ownable(msg.sender) {
        engineeringManager = msg.sender;
    }

    /**
     * @notice Registers verified bytecode execution profiles to assist routing nodes.
     */
    function registerInstructionProfile(
        address targetContract, 
        bytes32 verificationHash, 
        uint32 recommendedLanes
    ) external {
        require(msg.sender == engineeringManager, "AuthError: Caller identity matches no whitelisted manager node");
        
        runtimeProfiles[targetContract] = BytecodeProfile({
            verificationHash: verificationHash,
            recommendedLanesCount: recommendedLanes,
            isProfileActive: true
        });

        emit ProfileRegistered(targetContract, verificationHash, recommendedLanes);
    }
}
