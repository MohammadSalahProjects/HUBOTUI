import 'dart:convert';


import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;


class StudentDayManagerPage extends StatefulWidget {

  @override

  _StudentDayManagerPageState createState() => _StudentDayManagerPageState();

}


class _StudentDayManagerPageState extends State<StudentDayManagerPage> {

  List<DropdownMenuItem<String>> departmentDropdownItems = [];


  String selectedDepartmentId = '';


  List<DropdownMenuItem<String>> courseDropdownItems = [];


  String selectedCourseId = '';

  bool isDepartmentDialogOpen = false; // New variable to track dialog state


  @override

  void initState() {

    super.initState();


    fetchDepartments();

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


        _showDepartmentCourseSelectionDialog();

      } else {

        print('Failed to fetch courses: ${response.statusCode}');

      }

    } catch (error) {

      print('Error fetching courses: $error');

    }

  }


  void _showDepartmentCourseSelectionDialog() {

    showDialog(

      context: context,


      barrierDismissible: false, // Prevent dismissing dialog on outside tap


      builder: (BuildContext context) {

        isDepartmentDialogOpen = true; // Dialog is opened now


        return AlertDialog(

          title: Text('Select Department and Course'),

          content: Column(

            mainAxisSize: MainAxisSize.min,

            children: [

              DropdownButtonFormField(

                value: selectedDepartmentId,

                items: departmentDropdownItems,

                onChanged: (value) {

                  setState(() {

                    selectedDepartmentId = value.toString();

                  });


                  if (selectedDepartmentId.isNotEmpty) {

                    fetchCourses(selectedDepartmentId);

                  }

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

            ],

          ),

          actions: [

            TextButton(

              onPressed: () {

                print('Selected Department: $selectedDepartmentId');


                print('Selected Course: $selectedCourseId');


                Navigator.of(context).pop();

              },

              child: Text('Select'),

            ),

          ],

        );

      },

    ).then((_) {

      isDepartmentDialogOpen = false; // Dialog is closed now

    });

  }


  @override

  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: Text('Student Day Manager'),

      ),

      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            ElevatedButton(

              onPressed: () {

                if (!isDepartmentDialogOpen) {

                  // Check if dialog is not already open


                  _showDepartmentCourseSelectionDialog();

                }

              },

              child: Text('Add Subject'),

            ),

          ],

        ),

      ),

    );

  }

}

