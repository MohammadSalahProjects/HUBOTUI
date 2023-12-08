// ignore_for_file: use_build_context_synchronously, avoid_print, prefer_const_constructors, prefer_const_declarations, must_be_immutable, library_private_types_in_public_api, use_key_in_widget_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'StudentRegistrationScreen.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController usernameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool passwordsMatch = true;

  @override
  void dispose() {
    // Dispose controllers

    usernameController.dispose();

    passwordController.dispose();

    confirmPasswordController.dispose();

    super.dispose();
  }

  Future<void> signUpUser() async {
    final String apiUrl = 'http://192.168.1.9:8080/user/createUser';

    final Map<String, String> userData = {
      'userName': usernameController.text,
      'password': passwordController.text,
    };

    if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        passwordsMatch = false;
      });

      return;
    }

    try {
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200) {
        // Successful signup

        print('User signed up successfully');

        // Fetch user ID and navigate to the student registration screen

        String userId = await fetchUserId(usernameController.text);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StudentRegistrationScreen(
              userId:
                  userId, // Pass the fetched user ID to StudentRegistrationScreen
            ),
          ),
        );

        // Optionally, you can clear the text fields after successful signup

        usernameController.clear();

        passwordController.clear();
      } else {
        // Unsuccessful signup

        print('Failed to sign up user');

        // Handle error or display a message to the user
      }
    } catch (error) {
      // Handle any exceptions during the signup process

      print('Error signing up: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signup'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(),
                errorText: passwordsMatch ? null : "Passwords don't match",
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: signUpUser, // Remove the context parameter

              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }

  // Function to fetch user ID

  Future<String> fetchUserId(String username) async {
    final String apiUrl =
        'http://192.168.1.9:8080/user/getUserID?userName=$username';

    try {
      final http.Response response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final String userId = response.body; // User ID as plain string

        print('User ID: $userId');

        return userId;
      } else {
        print('Failed to fetch user ID: ${response.statusCode}');

        return ''; // Return empty string if failed to fetch user ID
      }
    } catch (error) {
      print('Error fetching user ID: $error');

      return ''; // Return empty string if error occurred
    }
  }
}
