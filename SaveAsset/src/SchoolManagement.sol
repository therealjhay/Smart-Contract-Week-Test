// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract SchoolManagement {
    address public owner;
    address public token;

    enum Status { ACTIVE, REMOVED, SUSPENDED }
    enum FeeStatus { UNPAID, PAID }

    struct Student {
        string name;
        uint256 level;
        Status status;
        FeeStatus feeStatus;
        uint256 lastPaymentTime;
    }

    struct Staff {
        string name;
        string role;
        Status status;
        uint256 salary;
    }

    mapping(address => Student) public students;
    mapping(address => Staff) public staffs;
    mapping(uint256 => uint256) public levelFees;

    address[] public studentList;
    address[] public staffList;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only admin can call this");
        _;
    }

    constructor(address _tokenAddress) {
        owner = msg.sender;
        token = _tokenAddress;
    }

    function setLevelFee(uint256 level, uint256 amount) external onlyOwner {
        require(level >= 100 && level <= 400, "Invalid level");
        levelFees[level] = amount;
    }

    function registerStudent(address _student, string memory _name, uint256 _level) external onlyOwner {
        require(students[_student].status != Status.ACTIVE, "Student already exists");
        require(_level >= 100 && _level <= 400, "Invalid level");

        students[_student] = Student({
            name: _name,
            level: _level,
            status: Status.ACTIVE,
            feeStatus: FeeStatus.UNPAID,
            lastPaymentTime: 0
        });
        studentList.push(_student);
    }

    function removeStudent(address _student) external onlyOwner {
        require(students[_student].status == Status.ACTIVE, "Student not active");
        students[_student].status = Status.REMOVED;
    }

    function paySchoolFees() external {
        require(students[msg.sender].status == Status.ACTIVE, "Student not active");
        require(students[msg.sender].feeStatus == FeeStatus.UNPAID, "Fees already paid");

        uint256 fee = levelFees[students[msg.sender].level];
        require(fee > 0, "Fee not set for this level");

        (bool success, ) = token.call(
            abi.encodeWithSignature("transferFrom(address,address,uint256)", msg.sender, address(this), fee)
        );
        require(success, "Token transfer failed");

        students[msg.sender].feeStatus = FeeStatus.PAID;
        students[msg.sender].lastPaymentTime = block.timestamp;
    }

    function employStaff(address _staff, string memory _name, string memory _role, uint256 _salary) external onlyOwner {
        require(staffs[_staff].status != Status.ACTIVE, "Staff already exists");

        staffs[_staff] = Staff({
            name: _name,
            role: _role,
            status: Status.ACTIVE,
            salary: _salary
        });
        staffList.push(_staff);
    }

    function suspendStaff(address _staff) external onlyOwner {
        require(staffs[_staff].status == Status.ACTIVE, "Staff not active");
        staffs[_staff].status = Status.SUSPENDED;
    }

    function payStaffSalary(address _staff) external onlyOwner {
        require(staffs[_staff].status == Status.ACTIVE, "Staff not active");

        (bool success, bytes memory data) = token.call(
            abi.encodeWithSignature("balanceOf(address)", address(this))
        );
        require(success, "Balance check failed");
        uint256 balance = abi.decode(data, (uint256));
        require(balance >= staffs[_staff].salary, "Insufficient contract balance");

        (success, ) = token.call(
            abi.encodeWithSignature("transfer(address,uint256)", _staff, staffs[_staff].salary)
        );
        require(success, "Token transfer failed");
    }

    function getStudentDetails(address _student) external view returns (
        string memory name,
        uint256 level,
        Status status,
        FeeStatus feeStatus,
        uint256 lastPaymentTime
    ) {
        Student memory s = students[_student];
        return (s.name, s.level, s.status, s.feeStatus, s.lastPaymentTime);
    }

    function getStaffDetails(address _staff) external view returns (
        string memory name,
        string memory role,
        Status status,
        uint256 salary
    ) {
        Staff memory s = staffs[_staff];
        return (s.name, s.role, s.status, s.salary);
    }

    function getAllStudents() external view returns (address[] memory) {
        return studentList;
    }

    function getAllStaff() external view returns (address[] memory) {
        return staffList;
    }

    function getContractTokenBalance() external returns (uint256) {
        (bool success, bytes memory data) = token.call(
            abi.encodeWithSignature("balanceOf(address)", address(this))
        );
        require(success, "Balance check failed");
        return abi.decode(data, (uint256));
    }

    function withdrawETH() external onlyOwner {
        (bool success, ) = payable(owner).call{value: address(this).balance}("");
        require(success, "Withdrawal failed");
    }

    receive() external payable {}
    fallback() external payable {}
}