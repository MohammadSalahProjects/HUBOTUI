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
    final String apiUrl = 'https://768f-2a01-9700-1a9a-7800-5b0-d5cd-7f59-3613.ngrok-free.app/user/createUser';
    final String checkUserUrl = 'https://768f-2a01-9700-1a9a-7800-5b0-d5cd-7f59-3613.ngrok-free.app/user/getUser';

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

    if (passwordController.text.length < 8 ||
        usernameController.text.length < 8) {
      setState(() {
        // Set passwordsMatch to true to avoid the error message for mismatched passwords
        passwordsMatch = true;
      });
      // Display error for passwords or username too short
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Password and username must be at least 8 characters long',
          ),
        ),
      );
      return;
    }

    try {
      // Check if username exists
      final http.Response userCheckResponse = await http.get(
        Uri.parse('$checkUserUrl?userName=${usernameController.text}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (userCheckResponse.statusCode == 200) {
        // Username exists, show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Username already exists'),
          ),
        );
        return;
      } else if (userCheckResponse.statusCode == 404) {
        // Username does not exist, proceed with signup
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
                userId: userId,
              ),
            ),
          );

          // Clear the text fields after successful signup
          usernameController.clear();
          passwordController.clear();
        } else {
          // Unsuccessful signup
          print('Failed to sign up user');
          // Handle error or display a message to the user
        }
      } else {
        // Other error cases when checking username existence
        print(
            'Error checking username existence: ${userCheckResponse.statusCode}');
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
        'https://768f-2a01-9700-1a9a-7800-5b0-d5cd-7f59-3613.ngrok-free.app/user/getUserID?userName=$username';

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
