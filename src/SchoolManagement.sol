// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SchoolManagement {

    string public name = "UnivToken";
    string public symbol = "Univt";
    uint8 public decimals = 18;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;

    mapping(address => mapping(address => uint256)) public allowance;

    address public owner; //admin mapping

    struct Student{
        string name;
        uint level;
        bool isRegistered;
        bool feePaid;
        uint256 paymentTimestamp;
    }

    struct Staff{
        string name;
        string role;
        bool isRegistered;
        uint256 lastPaidTimestamp;
    }

    mapping(address => Student) public students;
    mapping(address => Staff) public staffs;

    mapping(uint256 => uint256) public levelFees;

    address[] public staffList;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    event StudentRegistered(address indexed student, uint256 level);
    event FeePaid(address indexed student, uint256 amount, uint256 timestamp);
    event StaffRegistered(address indexed staff, string role);
    event SalaryPaid(address indexed staff, uint256 amount, uint256 timestamp);
    event FeeLevelSet(uint256 level, uint256 amount);

    constructor (uint256 _initialSupply){
        owner = msg.sender;

        totalSupply = _initialSupply * (10 ** uint256(decimals));
        balanceOf[owner] = totalSupply;
        emit Transfer(address(0), owner, totalSupply);
    }


    modifier onlyOwner() {
        require(msg.sender == owner, "Only Admin can call this");
        _;
    }

    function _transfer(address from, address to, uint256 amount) internal {
        require(to != address(0), "Transfer to zero address");
        require(balanceOf[from] >= amount, "Insufficient Balance");

        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        
        emit Transfer(from, to, amount);
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval (msg.sender, spender, amount);
        return true;
    }

    function transferFrom (address from, address to, uint256 amount) public returns (bool) {
        require(allowance[from] [msg.sender] >= amount, "Allowance exceeded");

        allowance[from][msg.sender] -= amount;

        _transfer(from, to, amount);
        return true;
    }

    function setLevelFee(uint256 _level, uint256 _amount) public onlyOwner {
        require(_level == 100 || _level == 200 || _level == 300 || _level == 400, "Invalid level");
        levelFees[_level] = _amount;
        emit FeeLevelSet(_level, _amount);
    }

    function registerStudent(string memory _name, uint256 _level) public {
        require(!students[msg.sender].isRegistered, "Already Registered");
        require(_level == 100 || _level == 200 || _level == 300 || _level == 400, "Invalid level");

        students[msg.sender] = Student ({
            name: _name,
            level: _level,
            isRegistered: true,
            feePaid: false,
            paymentTimestamp: 0
        });

        emit StudentRegistered(msg.sender, _level);
    }

    function paySchoolFees() public {
        require(students[msg.sender].isRegistered, "Not Registered");
        require(!students[msg.sender].feePaid, "Fees already paid");

        uint256 level = students[msg.sender].level;
        uint256 fee = levelFees[level];
        require(fee > 0, "Fee not set for this level");

        _transfer(msg.sender, address(this), fee);

        students[msg.sender].feePaid = true;
        students[msg.sender].paymentTimestamp = block.timestamp;

        emit FeePaid(msg.sender, fee, block.timestamp);
    }

    function registerStaff(address _staff, string memory _name, string memory _role) public onlyOwner {
        require(!staffs[_staff].isRegistered, "Staff exists");

        staffs[_staff] = Staff({
            name: _name,
            role: _role,
            isRegistered: true,
            lastPaidTimestamp: 0
        });

        staffList.push(_staff);
        emit StaffRegistered(_staff, _role);
    }

    function paySalary(address _staff, uint256 _amount) public onlyOwner {
        require(staffs[_staff].isRegistered, "Staff not found");
        require(balanceOf[address(this)] >= _amount, "School insufficient balance");

        _transfer(address(this), _staff, _amount);

        staffs[_staff].lastPaidTimestamp = block.timestamp;
        emit SalaryPaid(_staff, _amount, block.timestamp);
    }

    function getAllStaff() public view returns (address[] memory) {
        return staffList;
    }

    function getStudentDetails(address _student) public view returns (string memory, uint256, bool, uint256) {
        Student memory s = students[_student];
        return (s.name, s.level, s.feePaid, s.paymentTimestamp);
    }
}