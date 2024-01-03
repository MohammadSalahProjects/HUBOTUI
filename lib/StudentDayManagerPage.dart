// ignore_for_file: avoid_print, library_private_types_in_public_api, use_key_in_widget_constructors, use_build_context_synchronously, unused_element, use_super_parameters, prefer_const_declarations

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Notes.dart';

class AddSubjectDialog extends StatefulWidget {
  final String userId;
  final void Function(String) addSubject;

  const AddSubjectDialog({required this.userId, required this.addSubject});

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
  late final String studentId;
  List<String> addedSubjects = [];

  @override
  void initState() {
    super.initState();
    fetchDepartments();
  }

  String formatTimeOfDay(TimeOfDay timeOfDay) {
    final String formattedHour = timeOfDay.hour.toString().padLeft(2, '0');
    final String formattedMinute = timeOfDay.minute.toString().padLeft(2, '0');
    return '$formattedHour:$formattedMinute';
  }

  void _onSubjectAdded(String subjectInfo) async {
    await addScheduleSubject(); // Call the method to add the subject to the database
    _StudentDayManagerPageState state =
        context.findAncestorStateOfType<_StudentDayManagerPageState>()!;
    state._onSubjectAdded(subjectInfo);
  }

  Future<void> addScheduleSubject() async {
    const String studentDetailsApiUrl =
        'https://768f-2a01-9700-1a9a-7800-5b0-d5cd-7f59-3613.ngrok-free.app/registerStudent/getStudentByUserId?id=';

    const String apiUrl = 'https://768f-2a01-9700-1a9a-7800-5b0-d5cd-7f59-3613.ngrok-free.app/ScheduleSubjects/addSubject';

    const String courseUrl =
        'https://768f-2a01-9700-1a9a-7800-5b0-d5cd-7f59-3613.ngrok-free.app/course/getCourseById?courseId=';

    try {
      final http.Response studentResponse =
          await http.get(Uri.parse('$studentDetailsApiUrl${widget.userId}'));

      final http.Response courseResponse =
          await http.get(Uri.parse('$courseUrl$selectedCourseId'));

      if ((studentResponse.statusCode & courseResponse.statusCode) == 200) {
        final dynamic decodedResponse = jsonDecode(studentResponse.body);
        final String studentId = decodedResponse['id'];

        final dynamic decodedCourseResponse = jsonDecode(courseResponse.body);

        final Map<String, dynamic> requestData = {
          'student': decodedResponse,
          'course': decodedCourseResponse,
          'startTime': formatTimeOfDay(startTime!), // Formatting start time
          'endTime': formatTimeOfDay(endTime!),
          'selectedDays': selectedDays,
        };

        final http.Response response = await http.post(
          Uri.parse(apiUrl),
          body: jsonEncode(requestData),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          // Subject added successfully

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Subject added successfully'),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          // Failed to add subject
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Failed to add subject: ${studentId} ${response.statusCode}'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else {
        // Failed to fetch student details
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to fetch student details: ${studentResponse.statusCode}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      // Handle error cases here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> fetchDepartments() async {
    const String apiUrl =
        'https://768f-2a01-9700-1a9a-7800-5b0-d5cd-7f59-3613.ngrok-free.app/department/getAllDepartments';
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
        'https://768f-2a01-9700-1a9a-7800-5b0-d5cd-7f59-3613.ngrok-free.app/course/getAllCoursesInDepartment?departmentId=$departmentId';
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

  Future<void> fetchCourse(String courseId) async {
    final String apiUrl =
        'https://768f-2a01-9700-1a9a-7800-5b0-d5cd-7f59-3613.ngrok-free.app/course/getCourseById?courseId=$courseId';
    try {
      final http.Response response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        return decodedResponse;
      } else {
        print('Failed to fetch courses: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching courses: $error');
    }
  }
  Future<String?> fetchStudentId(String userId) async {
    final String studentIdApiUrl =
        'https://768f-2a01-9700-1a9a-7800-5b0-d5cd-7f59-3613.ngrok-free.app/registerStudent/getStudentIdByUserId?userId=$userId';

    try {
      final http.Response response = await http.get(Uri.parse(studentIdApiUrl));
      if (response.statusCode == 200) {
        final studentIdDecodedResponse = jsonDecode(response.body);
         studentIdDecodedResponse;
       return studentIdDecodedResponse;
      } else {
        print('Failed to fetch StudentId: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching StudentId: $error');
    }
  }

  Future<void> fetchStudentDetails(String userId) async {
    Future<String> fetchCourseIdByCourseName(String courseName) async {
      final String apiUrl =
          'https://768f-2a01-9700-1a9a-7800-5b0-d5cd-7f59-3613.ngrok-free.app/course/getCourseIdByCourseName?courseName=$courseName';

      try {
        final http.Response response = await http.get(Uri.parse(apiUrl));

        if (response.statusCode == 200) {
          return response.body;
        } else {
          print('Failed to fetch courseId: ${response.statusCode}');
          return '';
        }
      } catch (error) {
        print('Error fetching courseId: $error');
        return '';
      }
    }

    final String apiUrl =
        'https://768f-2a01-9700-1a9a-7800-5b0-d5cd-7f59-3613.ngrok-free.app/registerStudent/getStudentByUserId?id=$userId';

    try {
      final http.Response response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final dynamic decodedResponse = jsonDecode(response.body);
        studentId = decodedResponse['id'];

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
                  fetchCourses(selectedDepartmentId);
                });
              },
              decoration: InputDecoration(
                labelText: 'Department',
              ),
              isExpanded: true,
              selectedItemBuilder: (BuildContext context) {
                return departmentDropdownItems.map<Widget>((item) {
                  return Text(
                    (item.child as Text).data
                        as String, // Show the department name
                    overflow: TextOverflow.ellipsis,
                  );
                }).toList();
              },
              itemHeight: null,
            ),
            DropdownButtonFormField(
              value: selectedCourseId,
              items: courseDropdownItems,
              onChanged: (value) {
                setState(() {
                  selectedCourseId = value.toString();
                });
              },
              decoration: InputDecoration(
                labelText: 'Course',
              ),
              isExpanded: true,
              selectedItemBuilder: (BuildContext context) {
                return courseDropdownItems.map<Widget>((item) {
                  return Text(
                    (item.child as Text).data as String, // Show the course name
                    overflow: TextOverflow.ellipsis,
                  );
                }).toList();
              },
              itemHeight: null,
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
          onPressed: () async {
            try {
              await addScheduleSubject(); // Call the method to add the subject to the database
              Navigator.of(context)
                  .pop(); // Close the dialog after adding the subject
            } catch (error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: $error'),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
          child: const Text('Select'),
        ),
      ],
    );
  }
}

class StudentDayManagerPage extends StatefulWidget {
  final String userId;

  const StudentDayManagerPage({Key? key, required this.userId})
      : super(key: key);

  @override
  _StudentDayManagerPageState createState() => _StudentDayManagerPageState();
}

class _StudentDayManagerPageState extends State<StudentDayManagerPage> {
  List<String> addedSubjects = [];

  void addSubject(String subjectInfo) {
    setState(() {
      addedSubjects.add(subjectInfo);
    });
  }
  Future<String?> fetchSubjectId(String courseId) async {
    String studentId = fetchStudentId(widget.userId) as String;
    final String subjectIdApiUrl =
        'https://768f-2a01-9700-1a9a-7800-5b0-d5cd-7f59-3613.ngrok-free.app/ScheduleSubjects/getSpecificSubjectIdForStudent?studentId=$studentId&courseId=$courseId';

    try {
      final http.Response response = await http.get(Uri.parse(subjectIdApiUrl));
      if (response.statusCode == 200) {
        final subjectIdDecodedResponse = jsonDecode(response.body);
        subjectIdDecodedResponse;
        return subjectIdDecodedResponse;
      } else {
        print('Failed to fetch SubjectId: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching SubjectId: $error');
    }
  }
  Future<String?> fetchCourseIdByCourseName(String subjectInfo) async {
    try {
      if (!subjectInfo.contains(':') || !subjectInfo.contains('\n')) {
        print('Invalid subject format1: $subjectInfo');
        return null;
      }
      List<String> splitSubject = subjectInfo.split(':');
      if (splitSubject.length < 2) {
        print('Invalid subject format2: $subjectInfo');
        return null;
      }

      String courseName = splitSubject[1].split('\n')[0].trim();
      print(courseName);
      final String apiUrl =
          'https://768f-2a01-9700-1a9a-7800-5b0-d5cd-7f59-3613.ngrok-free.app/course/getCourseIdByCourseName?courseName=$courseName';

      final http.Response response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final dynamic decodedResponse = jsonDecode(response.body);
        print(decodedResponse['id'].toString());

        return decodedResponse['id'].toString();
      } else {
        print('Failed to fetch course ID: ${response.statusCode}');
        return null; // Return null in case of failure
      }
    } catch (error) {
      print('Error fetching course ID: $error');
      return null; // Return null in case of error
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSubjects(); // Call the method to fetch subjects for the current user
  }

  Future<void> _loadSubjects() async {
    try {
      List<String> subjects = await fetchSubjectsForUser(widget.userId);
      setState(() {
        addedSubjects = subjects;
      });
    } catch (error) {
      print('Error loading subjects: $error');
    }
  }

  void _onSubjectAdded(String subjectInfo) {
    setState(() {
      addedSubjects.add(subjectInfo);
    });
    _loadSubjects();
    Navigator.pop(context); // Close the dialog after adding the subject
  }

  Future<String> fetchStudentId(String userId) async {
    final String apiUrl =
        'https://768f-2a01-9700-1a9a-7800-5b0-d5cd-7f59-3613.ngrok-free.app/registerStudent/getStudentByUserId?id=$userId';

    try {
      final http.Response response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final dynamic decodedResponse = jsonDecode(response.body);
        return decodedResponse['id'];
      } else {
        print('Failed to fetch student details: ${response.statusCode}');
        return '';
      }
    } catch (error) {
      print('Error fetching student details: $error');
      return '';
    }
  }

  void deleteSubject(String courseId) async {
    print(courseId);
    print('entered');
    String studentId = await fetchStudentId(widget.userId);
    deleteSubjectFromBackend(courseId, studentId);
  }

  void deleteSubjectFromBackend(String courseId, String studentId) async {
    final String apiUrl =
        'https://768f-2a01-9700-1a9a-7800-5b0-d5cd-7f59-3613.ngrok-free.app/ScheduleSubjects/removeSubject';

    try {
      final http.Response response = await http.delete(
        Uri.parse('$apiUrl?courseId=$courseId&studentId=$studentId'),
      );

      if (response.statusCode == 200) {
        print('Subject deleted successfully');
        fetchSubjectsForUser(widget.userId);
        _loadSubjects();
      } else {
        print('Failed to delete subject: ${response.statusCode}');
      }
    } catch (error) {
      print('Error deleting subject: $error');
    }
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
            Expanded(
              child: ListView(
                children: addedSubjects.map((subjectInfo) {
                  return SubjectButton(
                    subjectInfo: subjectInfo,
                    userId: widget.userId,
                    onDelete: () async {
                      String? courseId =
                          await fetchCourseIdByCourseName(subjectInfo);
                      if (courseId != null) {
                        deleteSubject(courseId);
                        _loadSubjects(); // Refresh after deletion
                      } else {
                        print('Course ID is null for $subjectInfo');
                      }
                    },
                  );
                }).toList(),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              color: Colors.blue,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AddSubjectDialog(
                        userId: widget.userId,
                        addSubject: _onSubjectAdded,
                      );
                    },
                  );
                  _loadSubjects();
                },
                child: const Text('Add Subject'),
              ),
            ),


    ],

        ),
      ),
    );
  }
}

class SubjectButton extends StatelessWidget {
  final String subjectInfo;
  final String userId;
  final Function() onDelete;


  const SubjectButton({
    Key? key,
    required this.subjectInfo,
    required this.userId,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotePage(
                        userId: userId,
                        subjectInfo: subjectInfo,
                      ),
                    ),
                  );
                },
                child: Text(
                  'Add Note',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              GestureDetector(
                onTap: onDelete, // Modify this to delete
                child: const Icon(Icons.delete), // Delete icon
              ),
            ],
          ),
        ],
      ),
    );
  }
}


Future<List<String>> fetchSubjectsForUser(String userId) async {
  final String getStudentUri =
      'https://768f-2a01-9700-1a9a-7800-5b0-d5cd-7f59-3613.ngrok-free.app/registerStudent/getStudentByUserId?id=$userId';

  final String apiUrl =
      'https://768f-2a01-9700-1a9a-7800-5b0-d5cd-7f59-3613.ngrok-free.app/ScheduleSubjects/getSubjectForStudent?studentId=';

  try {
    final http.Response getStudentresponse =
        await http.get(Uri.parse(getStudentUri));
    if (getStudentresponse.statusCode == 200) {
      final dynamic decodedResponseStudent =
          jsonDecode(getStudentresponse.body);
      final String studentID = decodedResponseStudent['id'];

      final http.Response response =
          await http.get(Uri.parse('$apiUrl$studentID'));
      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = jsonDecode(response.body);
        List<String> subjects = decodedResponse.map<String>((subject) {
          // Extract necessary information from the subject object
          String courseName = subject['course']['courseName'];
          List<int> startTime = List<int>.from(subject['startTime']);
          List<int> endTime = List<int>.from(subject['endTime']);
          List<String> selectedDays =
              List<String>.from(subject['selectedDays']);

          // Create the subject info string using the extracted data
          return 'Course Name: $courseName\nStart Time: ${startTime[0]}:${startTime[1]}\nEnd Time: ${endTime[0]}:${endTime[1]}\nSelected Days: ${selectedDays.join(', ')}';
        }).toList();

        return subjects;
      } else {
        print('Failed to fetch subjects: ${response.statusCode}');
        return [];
      }
    } else {
      print('Failed to fetch userId: ${getStudentresponse.statusCode}');
      return [];
    }
  } catch (error) {
    print('Error fetching subjects: $error');
    return [];
  }

}
