// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {ISignatureUtils} from "@eigenlayer/contracts/interfaces/ISignatureUtils.sol";

interface ICCSOServiceManager {
    // Custom errors
    error CCSOServiceManager__TaskAlreadyResponded();
    error CCSOServiceManager__TaskHashMismatch();
    error CCSOServiceManager__InvalidSignature();
    error CCSOServiceManager__TaskNotFound();
    error CCSOServiceManager__InvalidChallenge();
    error CCSOServiceManager__ChallengePeriodActive();
    error CCSOServiceManager__InsufficientChallengeBond();
    error CCSOServiceManager__TaskNotChallenged();
    error CCSOServiceManager__CallerNotDisputeResolver();
    error CCSOServiceManager__CallerNotStakeRegistry();

    // Events
    event TaskResponded(uint32 indexed taskIndex, Task task, address indexed operator);
    event TaskChallenged(
        uint256 indexed chainId, uint256 blockNumber, bytes32 claimedState, address indexed operator
    );
    event ChallengeResolved(address indexed operator, uint32 indexed taskNum, bool challengeSuccessful);

    // Task struct
    struct Task {
        address user;
        uint256 chainId;
        uint256 blockNumber;
        uint256 key;
        uint256 value;
        uint32 taskCreatedBlock;
    }
    struct TaskResponse {
        Task task;
        uint256 responseBlock;
        bool challenged;
        bool resolved;
    }

    // Core functions
    function respondToTask(
        Task calldata task,
        uint32 referenceTaskIndex,
        bytes memory signature
    ) external;

    function handleChallengeResult(
        address operator,
        uint32 taskNum,
        bool challengeSuccessful
    ) external;

    // View functions
    function getTaskResponse(
        address operator, 
        uint32 taskNum
    ) external view returns (TaskResponse memory);

    function getTaskHash(
        uint32 taskNum
    ) external view returns (bytes32);
    function latestTaskNum() external view returns (uint32);

}
