// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hubot/chatbot_page.dart';
import 'package:hubot/signup_screen.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key});

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

  Future<String> fetchName(String userId) async {
    final String apiUrl =
        'https://768f-2a01-9700-1a9a-7800-5b0-d5cd-7f59-3613.ngrok-free.app/registerStudent/getName?userId=$userId';

    try {
      final http.Response response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final String name = response.body;
        print(name);
        return name;
      } else {
        return 'error fetching name'; // Handle case when fetching name fails
      }
    } catch (error) {
      print('Error fetching name: $error');
      return ''; // Handle error case
    }
  }

  Future<void> loginUser(String username, String password, BuildContext context,
      String userId) async {
    print('Attempting login for $username'); // Add this print statement

    final url = Uri.parse('https://768f-2a01-9700-1a9a-7800-5b0-d5cd-7f59-3613.ngrok-free.app/user/login');

    try {
      final response = await http.post(
        url,
        body: jsonEncode({'userName': username, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      print(
          'Response status code: ${response.statusCode}'); // Add this print statement

      if (response.statusCode == 200) {
        String userId = await fetchUserId(username);
        String fullName = await fetchName(userId);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatPage(
                    userName: fullName,
                    userId: userId,
                  )),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Login Failed'),
            content: const Text('Invalid credentials'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      print(
          'Error during login: $error'); // Add this print statement to catch any exceptions

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Failed'),
          content: const Text('Error during login. Please try again later.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String username = '';
    String password = '';

    return Scaffold(
      body: ListView(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(255, 0, 0, 1),
                  Color.fromARGB(255, 234, 100, 4)
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: CircleAvatar(
                    radius: 100.0,
                    backgroundImage: AssetImage('assets/images/HU logo.png'),
                  ),
                ),
                const SizedBox(height: 16.0),
                const SizedBox(height: 40),
                Text(
                  'HUBOT',
                  style: TextStyle(
                    fontSize: 48,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    onChanged: (value) => username = value,
                    decoration: InputDecoration(
                      labelText: 'username',
                      labelStyle: const TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.3),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.white.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.white.withOpacity(0.7)),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    onChanged: (value) => password = value,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: const TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.3),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.white.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.white.withOpacity(0.7)),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    String userId = await fetchUserId(username);
                    if (userId.isNotEmpty) {
                      await loginUser(username, password, context, userId);
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Login Failed'),
                          content: const Text('Failed to fetch User ID'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                  ),
                  child: const Text(
                    'Log in',
                    style: TextStyle(
                      color: Color.fromARGB(255, 201, 58, 58),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupScreen()),
                    );
                  },
                  child: const Text(
                    'Create an account',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
