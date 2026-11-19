// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract AttendanceRecord {
    address public instructor;
    string public courseTitle;

    mapping(address => bool) public hasAttended;
    address[] public attendees;

    event AttendanceRecorded(address indexed student, uint256 timestamp);
    event AttendanceRemoved(address indexed student);

    constructor(string memory _courseTitle) {
        instructor = msg.sender;
        courseTitle = _courseTitle;
    }

    modifier onlyInstructor() {
        require(msg.sender == instructor, "Only the instructor can perform this action.");
        _;
    }

    // Itinatala ang attendance ng estudyante; instructor lamang ang maaaring tumawag.
    function recordAttendance(address _student) external onlyInstructor {
        require(_student != address(0), "Invalid student address.");
        require(!hasAttended[_student], "Student is already recorded.");

        hasAttended[_student] = true;
        attendees.push(_student);

        emit AttendanceRecorded(_student, block.timestamp);
    }

    // Tinatanggal ang attendance ng estudyanteng naitala na; instructor lamang ang maaaring tumawag.
    function removeAttendance(address _student) external onlyInstructor {
        require(hasAttended[_student], "Student is not recorded.");

        hasAttended[_student] = false;

        for (uint256 i = 0; i < attendees.length; i++) {
            if (attendees[i] == _student) {
                attendees[i] = attendees[attendees.length - 1];
                attendees.pop();
                break;
            }
        }

        emit AttendanceRemoved(_student);
    }

    // Ibinabalik ang bilang ng mga kasalukuyang dumalo.
    function getAttendeeCount() external view returns (uint256) {
        return attendees.length;
    }

    // Ibinabalik ang buong listahan ng mga kasalukuyang dumalo.
    function getAttendees() external view returns (address[] memory) {
        return attendees;
    }

    // Sinusuri kung naitala ang attendance ng estudyante.
    function isAttending(address _student) external view returns (bool) {
        return hasAttended[_student];
    }
}
