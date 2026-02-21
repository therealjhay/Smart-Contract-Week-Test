// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract Todo {

    /* 
     A Struct is created to give user defined types,
     those types you know defines the project in front of you
     whih in this care are id (task box), title (task name), 
     isComplete (to check if task if done), timeCompleted (to state the time the task was done) 
    */
    struct Task {
        uint8 id;
        string title;
        bool isComplete;
        uint256 timeCompleted;
    }

    Task[] public tasks;
    uint8 todo_id;

    function createTask(string memory _title) external {
        todo_id = todo_id + 1; // this is how we create new tasks

        Task memory task = Task({id: todo_id, title: _title, isComplete: false, timeCompleted: 0}); // this is basically us giving default values to our struct (Task)

        tasks.push(task); // we are trying to give an instance to 
    }

    function getAllTasks() external view returns (Task[] memory) {
        return tasks;
    }

    function markComplete(uint8 _id) external {
        for (uint256 i; i < tasks.length; i++) {
            if (tasks[i].id == _id) {
                tasks[i].isComplete = true;
                tasks[i].timeCompleted = block.timestamp;
                break;
            }
        }
    }

    function deleteTask(uint8 _id) external {
        for (uint256 i; i < tasks.length; i++) {
            if (tasks[i].id == _id) {
                tasks[i] = tasks[tasks.length - 1];
                tasks.pop();
                break;
            }
        }
    }

    function editTask(uint8 _id, string memory _title, bool _isComplete) external {
        for (uint256 i; i < tasks.length; i++) {
            if (tasks[i].id == _id) {
                tasks[i].title = _title;
                tasks[i].isComplete = _isComplete;
                break;
            }
        }
    }
}
