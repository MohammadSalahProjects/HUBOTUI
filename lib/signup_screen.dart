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

  Future<void> signUpUser() async {
    final String apiUrl = 'http://192.168.1.7:8080/user/createUser';
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

      // Navigate to the student registration screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StudentRegistrationScreen(
            username: usernameController.text,
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
}
