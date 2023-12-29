// ignore_for_file: library_private_types_in_public_api, prefer_final_fields, prefer_const_declarations, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NotePage extends StatefulWidget {
  final String studentId;
  final String subjectId;

  const NotePage({super.key, required this.studentId, required this.subjectId});

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  TextEditingController _noteController = TextEditingController();
  String? existingNote;

  @override
  void initState() {
    super.initState();
    fetchExistingNote();
  }

  Future<void> fetchExistingNote() async {
    final String apiUrl = 'http://192.168.43.199:8080/note/getNote';
    try {
      final http.Response response = await http.get(Uri.parse(
          '$apiUrl?studentId=${widget.studentId}&subjectId=${widget.subjectId}'));

      if (response.statusCode == 200) {
        final dynamic decodedResponse = jsonDecode(response.body);
        setState(() {
          existingNote = decodedResponse['note'];
          _noteController.text = existingNote ?? ''; // Display existing note
        });
      } else {
        print('Failed to fetch existing note: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching existing note: $error');
    }
  }

  Future<void> updateNote() async {
    final String apiUrl = 'http://192.168.43.199:8080/note/updateNote';
    try {
      final http.Response response = await http.put(
        Uri.parse('$apiUrl?noteId=$widget.subjectId'),
        body: {'note': _noteController.text},
      );

      if (response.statusCode == 200) {
        // Note updated successfully
        print('Note updated successfully');
      } else {
        // Failed to update note
        print('Failed to update note: ${response.statusCode}');
      }
    } catch (error) {
      // Handle error cases here
      print('Error updating note: $error');
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
              onPressed: () {
                updateNote(); // Call the method to update the note
              },
              child: const Text('Save Note'),
            ),
          ],
        ),
      ),
    );
  }
}
