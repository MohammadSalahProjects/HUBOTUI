// ignore_for_file: use_build_context_synchronously, avoid_print, prefer_const_constructors, prefer_const_declarations, must_be_immutable, library_private_types_in_public_api, use_key_in_widget_constructors


import 'dart:convert';


import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:hubot/login.dart';


class StudentRegistrationScreen extends StatefulWidget {

  String userId;


  StudentRegistrationScreen({required this.userId});


  @override

  _StudentRegistrationScreenState createState() =>

      _StudentRegistrationScreenState();

}


class _StudentRegistrationScreenState extends State<StudentRegistrationScreen> {

  late String selectedDepartmentId = '';


  late String userId = '';


  List<DropdownMenuItem<String>> departmentDropdownItems = [];


  late TextEditingController firstNameController;


  late TextEditingController middleNameController;


  late TextEditingController lastNameController;


  late TextEditingController emailController;


  String selectedGender = 'Male'; // Set default value


  @override

  void initState() {

    super.initState();


    fetchDepartments();


    userId = widget.userId;


    // Initialize controllers


    firstNameController = TextEditingController();


    middleNameController = TextEditingController();


    lastNameController = TextEditingController();


    emailController = TextEditingController();

  }


  @override

  void dispose() {

    // Dispose controllers


    firstNameController.dispose();


    middleNameController.dispose();


    lastNameController.dispose();


    emailController.dispose();


    super.dispose();

  }


  Future<void> fetchDepartments() async {

    final String apiUrl =

        'http://192.168.1.9:8080/department/getDepartmentsByFaculty?facultyId=64e8a5085608901b630a4da6';


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


  Future<void> registerStudent() async {

    // Fetch the user ID


    final String studentApiUrl =

        'http://192.168.1.9:8080/registerStudent/createStudent';


    final Map<String, dynamic> studentData = {

      'user': {

        'id': userId, // Use the fetched user ID

      },

      'department': {

        'departmentId': selectedDepartmentId,

      },

      'firstName': firstNameController.text,

      'middleName': middleNameController.text,

      'lastName': lastNameController.text,

      'email': emailController.text,

      'gender': selectedGender,

    };


    try {

      final http.Response response = await http.post(

        Uri.parse(studentApiUrl),

        headers: <String, String>{

          'Content-Type': 'application/json; charset=UTF-8',

        },

        body: jsonEncode(studentData),

      );


      if (response.statusCode == 200) {

        print('Student registered successfully');


        // Reset form after successful registration


        firstNameController.clear();


        middleNameController.clear();


        lastNameController.clear();


        emailController.clear();


        selectedGender = 'Male'; // Reset gender


        setState(() {

          selectedDepartmentId = departmentDropdownItems.isNotEmpty

              ? departmentDropdownItems[0].value!

              : '';

        });


        Navigator.push(

          context,

          MaterialPageRoute(builder: (context) => LoginPage()),

        );

      } else {

        print('Failed to register student: ${response.statusCode}');

      }

    } catch (error) {

      print('Error registering student: $error');

    }

  }


  @override

  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: Text('Student Registration'),

      ),

      body: Padding(

        padding: EdgeInsets.all(16.0),

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: <Widget>[

            DropdownButtonFormField<String>(

              value: selectedDepartmentId,

              items: departmentDropdownItems,

              onChanged: (String? value) {

                setState(() {

                  selectedDepartmentId = value!;

                });

              },

              decoration: InputDecoration(

                labelText: 'Choose Department',

                border: OutlineInputBorder(),

              ),

            ),

            TextFormField(

              controller: firstNameController,

              decoration: InputDecoration(

                labelText: 'First Name',

                border: OutlineInputBorder(),

              ),

            ),

            SizedBox(height: 12),

            TextFormField(

              controller: middleNameController,

              decoration: InputDecoration(

                labelText: 'Middle Name',

                border: OutlineInputBorder(),

              ),

            ),

            SizedBox(height: 12),

            TextFormField(

              controller: lastNameController,

              decoration: InputDecoration(

                labelText: 'Last Name',

                border: OutlineInputBorder(),

              ),

            ),

            SizedBox(height: 12),

            TextFormField(

              controller: emailController,

              decoration: InputDecoration(

                labelText: 'Email',

                border: OutlineInputBorder(),

              ),

            ),

            SizedBox(height: 12),

            DropdownButtonFormField<String>(

              value: selectedGender,

              items: ['Male', 'Female'].map((String gender) {

                return DropdownMenuItem<String>(

                  value: gender,

                  child: Text(gender),

                );

              }).toList(),

              onChanged: (String? value) {

                setState(() {

                  selectedGender = value!;

                });

              },

              decoration: InputDecoration(

                labelText: 'Choose Gender',

                border: OutlineInputBorder(),

              ),

            ),

            SizedBox(height: 20),

            ElevatedButton(

              onPressed: () {

                registerStudent();

              },

              child: Text('Register Student'),

            ),

          ],

        ),

      ),

    );

  }

}

