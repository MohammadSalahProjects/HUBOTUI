import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NotePage extends StatefulWidget {
  final String userId;
  final String subjectInfo;

  const NotePage({Key? key, required this.userId, required this.subjectInfo}) : super(key: key);

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  TextEditingController _noteController = TextEditingController();
  String? existingNote;
  String? subjectId;
  String? studentId;
  String? existingNoteId;

  @override
  void initState() {
    super.initState();
    checkAndAddOrUpdateNote();
  }

  Future<String> fetchStudentId(String userId) async {
    final String apiUrl = 'https://768f-2a01-9700-1a9a-7800-5b0-d5cd-7f59-3613.ngrok-free.app/registerStudent/getStudentByUserId?id=${widget
        .userId}';

    try {
      final http.Response response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final dynamic decodedResponse = jsonDecode(response.body);
        print(studentId);
        return decodedResponse['id'].toString();
      } else {
        print('Failed to fetch student details: ${response.statusCode}');
        return '';
      }
    } catch (error) {
      print('Error fetching student details: $error');
      return '';
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

  Future<String> fetchSubjectIdByCourseId(String subjectInfo) async {
    try {
      studentId = await fetchStudentId(widget.userId);
      String? courseId = await fetchCourseIdByCourseName(subjectInfo);

      if (!subjectInfo.contains(':') || !subjectInfo.contains('\n')) {
        print('Invalid subject format1: $subjectInfo');
        return '';
      }
      List<String> splitSubject = subjectInfo.split(':');
      if (splitSubject.length < 2) {
        print('Invalid subject format2: $subjectInfo');
        return '';
      }

      String courseName = splitSubject[1].split('\n')[0].trim();
      print(courseName);
      final String apiUrl = 'https://768f-2a01-9700-1a9a-7800-5b0-d5cd-7f59-3613.ngrok-free.app/ScheduleSubjects/getSpecificSubjectForStudent?studentId=$studentId&courseId=$courseId';


      final http.Response response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final dynamic decodedResponse = jsonDecode(response.body);
        return decodedResponse['id'].toString();
      } else {
        print('Failed to fetch SubjectId: ${response.statusCode}');
        return '';
      }
    } catch (error) {
      print('Error fetching SubjectId: $error');
      return '';
    }
  }


  Future<void> checkAndAddOrUpdateNote() async {
    try {
      subjectId = await fetchSubjectIdByCourseId(widget.subjectInfo);
      studentId = await fetchStudentId(widget.userId);

      final String apiUrl = 'https://768f-2a01-9700-1a9a-7800-5b0-d5cd-7f59-3613.ngrok-free.app/note/getNote?studentId=$studentId&subjectId=$subjectId';
      final http.Response response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // If note exists, update the existing note
        final dynamic decodedResponse = jsonDecode(response.body);
        final String? noteFromDatabase = decodedResponse['note'];
        setState(() {
          existingNote = noteFromDatabase ?? ''; // Update existingNote value here
        });
        existingNoteId = decodedResponse['noteId'].toString();
      } else if (response.statusCode == 404) {
        // If note doesn't exist, set existingNote to null or an empty string
        setState(() {
          existingNote = ''; // or existingNote = null;
        });
      } else {
        print('Failed to check note existence: ${response.statusCode}');
      }
    } catch (error) {
      print('Error checking/adding/updating note: $error');
    }
  }


  Future<void> updateExistingNote() async {
    try {
      final String apiUrl = 'https://768f-2a01-9700-1a9a-7800-5b0-d5cd-7f59-3613.ngrok-free.app/note/updateNote?noteId=$existingNoteId&note=${_noteController.text}';
      final http.Response response = await http.put(
        Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        print('Note updated successfully');
      } else {
        print('Failed to update note: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating note: $error');
    }
  }

  Future<void> addNewNote() async {
    try {
      final String apiUrl = 'https://768f-2a01-9700-1a9a-7800-5b0-d5cd-7f59-3613.ngrok-free.app/note/addNote';
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode ({
          'student': {
            'id': studentId.toString(),
          },
          'subjects': {
            'subjectId': subjectId.toString(),
          },
          'note': _noteController.text.toString(),
        },),
      );

      if (response.statusCode == 200) {
        print('Note added successfully');
      } else {
        print('Failed to add note: ${response.statusCode}');
      }
    } catch (error) {
      print('Error adding note: $error');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Previous Note:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(existingNote ?? 'No previous note'), // Display existing note
            const SizedBox(height: 20),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'New Note',
                border: OutlineInputBorder(),
              ),
              minLines: 5,
              maxLines: null,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Call the method to update/add note when the button is pressed
                await checkAndAddOrUpdateNote();

                // Update UI to reflect changes
                setState(() {
                  String? note = existingNote;
                  existingNote = '${note ?? ''} ${_noteController.text}'; // Update existingNote with the new note
                  _noteController.clear(); // Clear the text in the TextField
                });
              },
              child: const Text('Save Note'),
            ),


          ],
        ),
      ),
    );
  }
}
