import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hubot/campusmap.dart';

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

  Future<String> getUserGender(String userId) async {
    final String apiUrl =
        'https://768f-2a01-9700-1a9a-7800-5b0-d5cd-7f59-3613.ngrok-free.app/registerStudent/getGender?userId=$userId';

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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<String>(
        future: getUserGender(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Return a placeholder or loading indicator while waiting for the data
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Handle error state
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final gender = snapshot.data;
            return Column(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.purple.shade200,
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    color:
                        Colors.purple.shade200, // Full-width purple background
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: gender == 'male'
                              ? const AssetImage(
                                  'assets/images/male_boy_person_people_avatar_icon_159358.png') // Display male photo
                              : const AssetImage(
                                  'assets/images/femaleuserlogo.png'), // Default female photo
                        ),
                        const SizedBox(
                            height:
                                10), // Added space between avatar and details
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '$username',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'User ID: $userId', // Displaying user ID
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                ListTile(
                  title: const Text('GPA Calculator'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GPACalculatorPage()),
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
                          builder: (context) => StudentDayManagerPage(
                                userId: userId,
                              )),
                    );
                  },
                ),
                ListTile(
                  title: const Text('Campus Map'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MapScreen()),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  title: const Text('Logout'),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/login');
                    // Navigate to Login page and replace the current route
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
