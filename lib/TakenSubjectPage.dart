import 'package:flutter/material.dart';
import 'login.dart';

class TakenSubjectsPage extends StatefulWidget {
  const TakenSubjectsPage({Key? key});

  @override
  _TakenSubjectsPageState createState() => _TakenSubjectsPageState();
}

class _TakenSubjectsPageState extends State<TakenSubjectsPage> {
  List<String> subjectTypes = [
    'University compulsory',
    'University elective',
    'Major elective',
    'Compulsory specialization',
    'College compulsory',
    'College elective',
  ];

  List<Map<String, dynamic>> subjects = [
    {
      'type': 'University compulsory',
      'subjects': [
        {
          'name': 'Subject 1',
          'grade': null,
          'year': '',
          'semester': '',
          'grades': [
            'A+',
            'A',
            'A-',
            'B+',
            'B',
            'B-',
            'C+',
            'C',
            'C-',
            'D+',
            'D',
            'D-',
            'F',
          ],
        },
        // Add more subjects here
      ],
    },
    {
      'type': 'University elective',
      'subjects': [
        {
          'name': 'Subject 2',
          'grade': null,
          'year': '',
          'semester': '',
          'grades': [
            'A+',
            'A',
            'A-',
            'B+',
            'B',
            'B-',
            'C+',
            'C',
            'C-',
            'D+',
            'D',
            'D-',
            'F',
          ],
        },
        // Add more subjects here
      ],
    },
    // Add more subject types here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Taken Subjects'),
      ),
      body: ListView.builder(
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          String subjectType = subjects[index]['type'];
          List<Map<String, dynamic>> subjectList = subjects[index]['subjects'];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  subjectType,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: subjectList.length,
                itemBuilder: (context, subIndex) {
                  String subjectName = subjectList[subIndex]['name'];
                  List<String> gradeOptions = subjectList[subIndex]['grades'];

                  return ListTile(
                    title: Text(subjectName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Grade'),
                        DropdownButtonFormField<String>(
                          value: subjectList[subIndex]['grade'],
                          items: gradeOptions
                              .map((grade) => DropdownMenuItem<String>(
                                    value: grade,
                                    child: Text(grade),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              subjectList[subIndex]['grade'] = value;
                            });
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text('Year'),
                        TextFormField(
                          initialValue: subjectList[subIndex]['year'],
                          onChanged: (value) {
                            setState(() {
                              subjectList[subIndex]['year'] = value;
                            });
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text('Semester (optional)'),
                        TextFormField(
                          initialValue: subjectList[subIndex]['semester'],
                          onChanged: (value) {
                            setState(() {
                              subjectList[subIndex]['semester'] = value;
                            });
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const Divider(),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to the login page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ),
          );
        },
        label: const Text('Finish'),
        icon: const Icon(Icons.check),
      ),
    );
  }
}
