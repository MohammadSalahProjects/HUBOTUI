// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'GPACalculatorPage.dart';
import 'StudentDayManagerPage.dart';

class SlideMenu extends StatelessWidget {
  final String username;
  final String userId;

  const SlideMenu({
    Key? key,
    required this.username,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.purple.shade200,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: getUserGender(userId).toString() == 'female'
                      ? const AssetImage('assets/images/femaleuserlogo.png')
                      : const AssetImage(
                          'assets/images/male_boy_person_people_avatar_icon_159358.png'),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$username',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'User ID: $userId', // Displaying user ID
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 8,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),

          ListTile(
            title: const Text('GPA Calculator'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GPACalculatorPage()),
              );
            },
          ),
          ListTile(
            title: const Text('Student Day Manager'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => StudentDayManagerPage()),
              );
            },
          ),
          ListTile(
            title: const Text('Campus Map'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to Campus Map page
            },
          ),
          // ListTile(
          //   title: const Text('FAQ'),
          //   onTap: () {
          //     Navigator.pop(context);
          //     // Navigate to FAQ page
          //   },
          // ),
          const Divider(),
          ListTile(
            title: const Text('Logout'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/login');
              // Navigate to Login page and replace the current route
            },
          ),
        ],
      ),
    );
  }
}

Future<String> getUserGender(String userId) async {
  final String apiUrl =
      'http://192.168.1.9:8080/registerStudent/getGender?userId=$userId';

  try {
    final http.Response response = await http.get(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final String gender = response.body;
      print(gender);
      return gender;
    } else {
      return 'error fetching name'; // Handle case when fetching name fails
    }
  } catch (error) {
    print('Error fetching name: $error');
    return ''; // Handle error case
  }
}
