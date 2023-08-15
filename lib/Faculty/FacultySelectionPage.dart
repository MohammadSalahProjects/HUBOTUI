import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hubot/Department/Department_model.dart'; // Assuming you have the Department class
import 'package:hubot/Major/Major_model.dart'; // Assuming you have the Major class
import 'package:hubot/Faculty/Faculty_model.dart'; // Assuming you have the Faculty class

class FacultySelectionPage extends StatefulWidget {
  @override
  _FacultySelectionPageState createState() => _FacultySelectionPageState();
}

class _FacultySelectionPageState extends State<FacultySelectionPage> {
  List<Department> _departments = [];
  List<Major> _majors = [];
  List<Faculty> _faculties = [];

  Department? _selectedDepartment;
  Major? _selectedMajor;
  Faculty? _selectedFaculty;

  @override
  void initState() {
    super.initState();
    _fetchDepartments();
    _fetchFaculties();
  }

  Future<void> _fetchDepartments() async {
    // Fetch departments from API
  }

  Future<void> _fetchFaculties() async {
    // Fetch faculties from API
  }

  Future<void> _fetchMajorsForDepartment(Department department) async {
    final Uri uri =
        Uri.parse('http://192.168.1.9:8080/major/getAllMajorByDepartment');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> rawData = json.decode(response.body);
        final List<Major> majors =
            rawData.map((json) => Major.fromJson(json)).toList();
        setState(() {
          _majors = majors;
        });
      } else {
        _handleError(response.statusCode);
      }
    } catch (e) {
      _handleError(null); // Handle network or other errors
    }
  }

  void _handleError(int? statusCode) {
    // Handle errors based on status code or other factors
    // For example, show an error dialog or update the UI
    print('Error occurred: Status Code: $statusCode');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Faculty, Department, and Major'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<Department>(
              value: _selectedDepartment,
              items: _departments.map((department) {
                return DropdownMenuItem(
                  value: department,
                  child: Text(department.name),
                );
              }).toList(),
              onChanged: (department) {
                setState(() {
                  _selectedDepartment = department;
                  _selectedMajor = null;
                });

                // Fetch majors for the selected department
                _fetchMajorsForDepartment(department!);
              },
              decoration: const InputDecoration(labelText: 'Department'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Major>(
              value: _selectedMajor,
              items: _majors.map((major) {
                return DropdownMenuItem(
                  value: major,
                  child: Text(major.name),
                );
              }).toList(),
              onChanged: (major) {
                setState(() {
                  _selectedMajor = major;
                });
              },
              decoration: const InputDecoration(labelText: 'Major'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Faculty>(
              value: _selectedFaculty,
              items: _faculties.map((faculty) {
                return DropdownMenuItem(
                  value: faculty,
                  child: Text(faculty.name),
                );
              }).toList(),
              onChanged: (faculty) {
                setState(() {
                  _selectedFaculty = faculty;
                });
              },
              decoration: const InputDecoration(labelText: 'Faculty'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_selectedDepartment != null &&
                    _selectedMajor != null &&
                    _selectedFaculty != null) {
                  // Perform any action you want with the selected department, major, and faculty
                  // For demonstration purposes, we'll just show a message.
                  _showMessageDialog(
                    'Selected Department: ${_selectedDepartment!.name}\n'
                    'Selected Major: ${_selectedMajor!.name}\n'
                    'Selected Faculty: ${_selectedFaculty!.name}',
                  );
                }
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showMessageDialog(String message) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Department, Major, and Faculty Selection'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
