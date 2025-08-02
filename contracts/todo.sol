// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

struct Task{
    string taskName;
    bool isCompleted;
}

contract TodoApp{
   mapping(uint256 => Task[]) public tasksList;


   function addTask(uint256 _userId, string memory _taskName, bool isCompleted) public {
        tasksList[_userId].push(Task(_taskName, isCompleted));
   }

   function getTask(uint256 _userId) public view returns (Task[] memory){
        return tasksList[_userId];
   }

   function markTaskAsCompleted(uint256 _userId, uint256 _taskId) public {
        tasksList[_userId][_taskId].isCompleted = true;
   }

   function updateTask(uint256 _userId, uint256 _taskId, string memory _newTask) public {
        tasksList[_userId][_taskId].taskName = _newTask;
   }
}