// ignore_for_file: use_build_context_synchronously


import 'dart:convert';


import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:hubot/chatbot_page.dart';

import 'package:hubot/signup_screen.dart';


class LoginPage extends StatelessWidget {

  const LoginPage({Key? key});


  Future<void> loginUser(

      String username, String password, BuildContext context) async {

    print('Attempting login for $username'); // Add this print statement


    final url = Uri.parse('http://192.168.1.9:8080/user/login');


    try {

      final response = await http.post(

        url,

        body: jsonEncode({'userName': username, 'password': password}),

        headers: {'Content-Type': 'application/json'},

      );


      print(

          'Response status code: ${response.statusCode}'); // Add this print statement


      if (response.statusCode == 200) {

        Navigator.push(

          context,

          MaterialPageRoute(builder: (context) => ChatPage()),

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

                  onPressed: () {

                    loginUser(username, password, context);

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

