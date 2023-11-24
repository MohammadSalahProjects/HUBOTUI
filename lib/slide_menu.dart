import 'package:flutter/material.dart';

import 'GPACalculatorPage.dart';
import 'StudentDayManagerPage.dart';

class SlideMenu extends StatelessWidget {
  const SlideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: (Colors.purple.shade200),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      AssetImage('assets/images/mohammadsalah.jpg'),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'mohammad salah',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Logged In',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
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
          ListTile(
            title: const Text('FAQ'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to FAQ page
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
      ),
    );
  }
}
