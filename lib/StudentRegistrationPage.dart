// ignore_for_file: library_private_types_in_public_api, prefer_final_fields, prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, avoid_print, unused_local_variable
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Student {
  final String firstName;
  final String lastName;
  final String department;
  final String major;

  Student({
    required this.firstName,
    required this.lastName,
    required this.department,
    required this.major,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'department': department,
      'major': major,
    };
  }
}

class User {
  final String userName;
  final String password;
  final String email;
  final String gender;

  User({
    required this.userName,
    required this.password,
    required this.email,
    required this.gender,
  });
}

class StudentRegistrationPage extends StatefulWidget {
  final User user;

  StudentRegistrationPage({required this.user});

  @override
  _StudentRegistrationPageState createState() =>
      _StudentRegistrationPageState();
}

class _StudentRegistrationPageState extends State<StudentRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  String _selectedFaculty = '';
  String _selectedDepartment = '';
  String _selectedMajor = '';

  List<String> _faculties = [];
  Map<String, List<String>> _departmentsByFaculty = {};
  List<String> _majorsList = [];

  Future<void> fetchFacultiesAndDepartments() async {
    final facultiesResponse = await http
        .get(Uri.parse('https://768f-2a01-9700-1a9a-7800-5b0-d5cd-7f59-3613.ngrok-free.app/faculty/getAllFaculties'));
    final departmentsResponse = await http
        .get(Uri.parse('https://768f-2a01-9700-1a9a-7800-5b0-d5cd-7f59-3613.ngrok-free.app/department/getAllDepartments'));

    if (facultiesResponse.statusCode == 200 &&
        departmentsResponse.statusCode == 200) {
      final facultiesData = json.decode(facultiesResponse.body);
      final departmentsData = json.decode(departmentsResponse.body);

      setState(() {
        _faculties = List<String>.from(facultiesData);
        _departmentsByFaculty = Map<String, List<String>>.from(departmentsData);
      });
    } else {
      print('Failed to fetch faculties and departments');
    }
  }

  Future<void> fetchMajorsByDepartment(String department) async {
    final response = await http.get(Uri.parse(
        'https://768f-2a01-9700-1a9a-7800-5b0-d5cd-7f59-3613.ngrok-free.app/major/getAllMajorByDepartment?department=$department'));

    if (response.statusCode == 200) {
      final majorsData = json.decode(response.body);

      setState(() {
        _majorsList = List<String>.from(majorsData);
      });
    } else {
      print('Failed to fetch majors for department: $department');
    }
  }

  void _updateDepartmentsForSelectedFaculty(String selectedFaculty) {
    setState(() {
      _selectedDepartment = '';
    });
    fetchMajorsByDepartment(_selectedDepartment);
  }

  @override
  void initState() {
    super.initState();
    fetchFacultiesAndDepartments();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Registration'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'First Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the first name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the last name';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedFaculty,
                items: _faculties.map((faculty) {
                  return DropdownMenuItem(value: faculty, child: Text(faculty));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedFaculty = value!;
                    _updateDepartmentsForSelectedFaculty(value);
                  });
                },
                decoration: InputDecoration(labelText: 'Faculty'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedDepartment,
                items:
                    _departmentsByFaculty[_selectedFaculty]?.map((department) {
                          return DropdownMenuItem(
                              value: department, child: Text(department));
                        }).toList() ??
                        [],
                onChanged: (value) {
                  setState(() {
                    _selectedDepartment = value!;
                    fetchMajorsByDepartment(_selectedDepartment);
                  });
                },
                decoration: InputDecoration(labelText: 'Department'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedMajor,
                items: _majorsList.map((major) {
                  return DropdownMenuItem(value: major, child: Text(major));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMajor = value!;
                  });
                },
                decoration: InputDecoration(labelText: 'Major'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final student = Student(
                      firstName: _firstNameController.text,
                      lastName: _lastNameController.text,
                      department: _selectedDepartment,
                      major: _selectedMajor,
                    );
                    // You can now call the API to register the student with the provided data
                    // _registerStudent(student);
                    _firstNameController.clear();
                    _lastNameController.clear();
                    _selectedFaculty = '';
                    _selectedDepartment = '';
                    _selectedMajor = '';
                  }
                },
                child: Text('Register Student'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
