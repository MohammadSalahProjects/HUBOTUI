// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddSubjectDialog extends StatefulWidget {
  final String userId;
  const AddSubjectDialog({required this.userId});

  @override
  _AddSubjectDialogState createState() => _AddSubjectDialogState();
}

class _AddSubjectDialogState extends State<AddSubjectDialog> {
  List<DropdownMenuItem<String>> departmentDropdownItems = [];
  String selectedDepartmentId = '';
  List<DropdownMenuItem<String>> courseDropdownItems = [];
  String selectedCourseId = '';
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  List<String> selectedDays = [];

  @override
  void initState() {
    super.initState();
    fetchDepartments();
  }

  Future<void> addScheduleSubject() async {
    final String apiUrl = 'http://192.168.1.9:8080/ScheduleSubjects/addSubject';

    final Map<String, dynamic> requestData = {
      'student': 'studentId', // Replace with actual student ID
      'course': selectedCourseId,
      'startTime': startTime.toString(),
      'endTime': endTime.toString(),
      'selectedDays': selectedDays,
    };

    try {
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode(requestData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        String subjectDetails = 'Course: $selectedCourseId\n'
            'Start Time: ${startTime.toString()}\n'
            'End Time: ${endTime.toString()}\n'
            'Days: ${selectedDays.join(', ')}';

        // Call the callback function to add the subject
        StudentDayManagerPage(userId: widget.userId).addSubject(subjectDetails);

        print('Subject added successfully!');
        Navigator.of(context).pop();
      } else {
        print('Failed to add subject: ${response.statusCode}');
        // Handle error cases here
      }
    } catch (error) {
      print('Error adding subject: $error');
      // Handle error cases here
    }
  }

  Future<void> fetchDepartments() async {
    final String apiUrl =
        'http://192.168.1.9:8080/department/getAllDepartments';
    try {
      final http.Response response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = jsonDecode(response.body);
        List<DropdownMenuItem<String>> departments =
            decodedResponse.map<DropdownMenuItem<String>>((department) {
          return DropdownMenuItem<String>(
            value: department['departmentId'],
            child: Text(department['departmentName']),
          );
        }).toList();

        setState(() {
          departmentDropdownItems = departments;
          selectedDepartmentId = departmentDropdownItems.isNotEmpty
              ? departmentDropdownItems[0].value!
              : ''; // Set default value if available
        });
      } else {
        print('Failed to fetch departments: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching departments: $error');
    }
  }

  Future<void> fetchCourses(String departmentId) async {
    final String apiUrl =
        'http://192.168.1.9:8080/course/getAllCoursesInDepartment?departmentId=$departmentId';
    try {
      final http.Response response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = jsonDecode(response.body);
        List<DropdownMenuItem<String>> courses =
            decodedResponse.map<DropdownMenuItem<String>>((course) {
          return DropdownMenuItem<String>(
            value: course['courseId'],
            child: Text(course['courseName']),
          );
        }).toList();

        setState(() {
          courseDropdownItems = courses;
          selectedCourseId = courseDropdownItems.isNotEmpty
              ? courseDropdownItems[0].value!
              : ''; // Set default value if available
        });
      } else {
        print('Failed to fetch courses: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching courses: $error');
    }
  }

  Future<void> fetchStudentDetails(String userId) async {
    final String apiUrl =
        'http://192.168.1.9:8080/getStudentByUserId?userName=$userId';

    try {
      final http.Response response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final dynamic decodedResponse = jsonDecode(response.body);
        final String studentId = decodedResponse['studentId'];

        // Use the retrieved student ID to create the ScheduleSubjects entry
        // Call the function to add ScheduleSubjects with the obtained studentId
        // Example: addScheduleSubject(studentId);
      } else {
        print('Failed to fetch student details: ${response.statusCode}');
        // Handle error cases here
      }
    } catch (error) {
      print('Error fetching student details: $error');
      // Handle error cases here
    }
  }

  void _changeSelectedDay(String day, bool? value) {
    setState(() {
      if (value != null && value) {
        selectedDays.add(day);
      } else {
        selectedDays.remove(day);
      }
    });
  }

  List<Widget> _buildDayCheckboxes() {
    return [
      for (var day in ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday'])
        CheckboxListTile(
          title: Text(day),
          value: selectedDays.contains(day),
          onChanged: (bool? value) {
            setState(() {
              if (value != null && value) {
                selectedDays.add(day);
              } else {
                selectedDays.remove(day);
              }
            });
          },
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Department, Course, Time, and Days'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select Days:'),
            ..._buildDayCheckboxes(),
            DropdownButtonFormField(
              value: selectedDepartmentId,
              items: departmentDropdownItems,
              onChanged: (value) {
                setState(() {
                  selectedDepartmentId = value.toString();
                  fetchCourses(
                      selectedDepartmentId); // Fetch courses on department selection change
                });
              },
            ),
            DropdownButtonFormField(
              value: selectedCourseId,
              items: courseDropdownItems,
              onChanged: (value) {
                setState(() {
                  selectedCourseId = value.toString();
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Start Time:'),
                TextButton(
                  onPressed: () async {
                    final TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        startTime = picked;
                      });
                    }
                  },
                  child: Text(startTime?.format(context) ?? 'Select'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('End Time:'),
                TextButton(
                  onPressed: () async {
                    final TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        endTime = picked;
                      });
                    }
                  },
                  child: Text(endTime?.format(context) ?? 'Select'),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Print selected values and close dialog
            print('Selected Department: $selectedDepartmentId');
            print('Selected Course: $selectedCourseId');
            print('Start Time: $startTime');
            print('End Time: $endTime');
            print('Selected Days: $selectedDays');
            Navigator.of(context).pop();
          },
          child: const Text('Select'),
        ),
      ],
    );
  }
}

class StudentDayManagerPage extends StatefulWidget {
  final String userId;

  // Correct constructor with required userId parameter
  const StudentDayManagerPage({Key? key, required this.userId})
      : super(key: key);

  @override
  _StudentDayManagerPageState createState() => _StudentDayManagerPageState();

  void addSubject(String subjectInfo) {
    _StudentDayManagerPageState().addSubject(subjectInfo);
  }
}

class _StudentDayManagerPageState extends State<StudentDayManagerPage> {
  List<String> addedSubjects = [];

  void addSubject(String subjectInfo) {
    setState(() {
      addedSubjects.add(subjectInfo);
    });
  }

  void deleteSubject(int index) {
    setState(() {
      addedSubjects.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Day Manager'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AddSubjectDialog(userId: widget.userId);
                  },
                );
              },
              child: const Text('Add Subject'),
            ),
            // Display added subjects as rectangular buttons
            Column(
              children: addedSubjects.asMap().entries.map((entry) {
                int index = entry.key;
                String subjectInfo = entry.value;
                return SubjectButton(
                  subjectInfo: subjectInfo,
                  onDelete: () => deleteSubject(index),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class SubjectButton extends StatelessWidget {
  final String subjectInfo;
  final Function()? onDelete;

  const SubjectButton({
    Key? key,
    required this.subjectInfo,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selected Subject:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4.0),
          Text(
            subjectInfo,
            style: const TextStyle(fontSize: 16.0),
          ),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: onDelete,
                child: const Icon(Icons.clear),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
