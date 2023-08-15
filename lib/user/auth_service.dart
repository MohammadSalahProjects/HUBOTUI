import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum Gender {
  Male,
  Female,
}

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _majorController = TextEditingController();
  Gender _selectedGender = Gender.Male; // Default gender

  Future<void> _showMessageDialog(BuildContext context, String message) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Registration'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _signup(
    String username,
    String password,
    String email,
    Gender gender,
    String major,
  ) async {
    final Uri uri = Uri.parse(
        'http://localhost:8080/user/createUser'); // Update with your backend URL
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'userName': username,
        'password': password,
        'email': email,
        'gender': gender.toString(),
        'major': major,
      }),
    );

    if (response.statusCode == 200) {
      _showMessageDialog(context, 'Registration successful. Please log in.');
    } else {
      _showMessageDialog(context, 'Registration failed. Please try again.');
    }
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _majorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _userNameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a password';
                  }
                  // Add additional password validation if needed
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an email';
                  }
                  // Add additional email validation if needed
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _majorController,
                decoration: InputDecoration(labelText: 'Major'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your major';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<Gender>(
                value: _selectedGender,
                items: [
                  DropdownMenuItem(
                    value: Gender.Male,
                    child: Text('Male'),
                  ),
                  DropdownMenuItem(
                    value: Gender.Female,
                    child: Text('Female'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value!;
                  });
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _signup(
                      _userNameController.text,
                      _passwordController.text,
                      _emailController.text,
                      _selectedGender,
                      _majorController.text,
                    );
                  }
                },
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hubot App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/signup', // Start with the signup screen
      routes: {
        '/signup': (context) => SignupScreen(),
        // Add more routes as needed
      },
    );
  }
}
