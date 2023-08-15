import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'chatbot_page.dart';
import 'slide_menu.dart';

class StudentDayManagerPage extends StatefulWidget {
  @override
  _StudentDayManagerPageState createState() => _StudentDayManagerPageState();
}

class _StudentDayManagerPageState extends State<StudentDayManagerPage> {
  List<SubjectData> _subjectDataList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Student Day Manager',
          style: GoogleFonts.adamina(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 248, 247, 247)),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 158, 37, 160).withOpacity(0.3),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatPage()),
              );
            },
            icon: Icon(Icons.home),
          ),
        ],
      ),
      drawer: SlideMenu(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple.shade200, Colors.pink.shade200],
          ),
        ),
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_subjectDataList.isEmpty)
              const Text(
                'No subjects added',
                style: TextStyle(fontSize: 16),
              ),
            if (_subjectDataList.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _subjectDataList.length,
                  itemBuilder: (context, index) {
                    SubjectData subjectData = _subjectDataList[index];
                    return Card(
                      child: InkWell(
                        onTap: () {
                          _showSubjectDialog(subjectData);
                        },
                        child: ListTile(
                          title: Text(subjectData.subjectName),
                          subtitle: Text(subjectData.schedule),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'remove') {
                                _removeSubject(subjectData);
                              } else if (value == 'edit') {
                                _editSubject(subjectData);
                              }
                            },
                            itemBuilder: (BuildContext context) {
                              return {'remove', 'edit'}.map((String choice) {
                                return PopupMenuItem<String>(
                                  value: choice,
                                  child: Text(choice),
                                );
                              }).toList();
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddSubjectDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddSubjectDialog() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController subjectNameController = TextEditingController();
        TextEditingController lectureTimeController = TextEditingController();
        String selectedDays = '135';

        return AlertDialog(
          title: Text('Add Subject'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: subjectNameController,
                decoration: InputDecoration(
                  labelText: 'Subject Name',
                ),
              ),
              TextField(
                controller: lectureTimeController,
                decoration: InputDecoration(
                  labelText: 'Lecture Time',
                ),
              ),
              DropdownButtonFormField<String>(
                value: selectedDays,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedDays = newValue;
                    });
                  }
                },
                items: [
                  DropdownMenuItem<String>(
                    value: '135',
                    child: Text('135'),
                  ),
                  DropdownMenuItem<String>(
                    value: '24',
                    child: Text('24'),
                  ),
                ],
                decoration: InputDecoration(
                  labelText: 'Days',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String subjectName = subjectNameController.text.trim();
                String lectureTime = lectureTimeController.text.trim();
                SubjectData newSubject = SubjectData(
                  subjectName: subjectName,
                  schedule: 'Time: $lectureTime, Days: $selectedDays',
                );
                setState(() {
                  _subjectDataList.add(newSubject);
                });
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showSubjectDialog(SubjectData subjectData) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(subjectData.subjectName),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Schedule: ${subjectData.schedule}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showSubjectNotesPage(subjectData);
              },
              child: Text('Add Notes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showSetReminderPage(subjectData);
              },
              child: Text('Set Reminder'),
            ),
          ],
        );
      },
    );
  }

  void _showSubjectNotesPage(SubjectData subjectData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubjectNotesPage(subjectData: subjectData),
      ),
    );
  }

  void _showSetReminderPage(SubjectData subjectData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SetReminderPage(subjectData: subjectData),
      ),
    );
  }

  void _removeSubject(SubjectData subjectData) {
    setState(() {
      _subjectDataList.remove(subjectData);
    });
  }

  void _editSubject(SubjectData subjectData) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController subjectNameController =
            TextEditingController(text: subjectData.subjectName);
        TextEditingController lectureTimeController = TextEditingController(
            text: subjectData.schedule.replaceAll('Time: ', '').split(',')[0]);
        String selectedDays = subjectData.schedule.replaceAll('Days: ', '');

        return AlertDialog(
          title: Text('Edit Subject'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: subjectNameController,
                decoration: InputDecoration(
                  labelText: 'Subject Name',
                ),
              ),
              TextField(
                controller: lectureTimeController,
                decoration: InputDecoration(
                  labelText: 'Lecture Time',
                ),
              ),
              DropdownButtonFormField<String>(
                value: selectedDays,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedDays = newValue;
                    });
                  }
                },
                items: [
                  DropdownMenuItem<String>(
                    value: '135',
                    child: Text('135'),
                  ),
                  DropdownMenuItem<String>(
                    value: '24',
                    child: Text('24'),
                  ),
                ],
                decoration: InputDecoration(
                  labelText: 'Days',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String newSubjectName = subjectNameController.text.trim();
                String newLectureTime = lectureTimeController.text.trim();
                String newSchedule =
                    'Time: $newLectureTime, Days: $selectedDays';
                setState(() {
                  subjectData.subjectName = newSubjectName;
                  subjectData.schedule = newSchedule;
                });
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

class SubjectData {
  String subjectName;
  String schedule;

  SubjectData({required this.subjectName, required this.schedule});
}

class SubjectNotesPage extends StatelessWidget {
  final SubjectData subjectData;

  SubjectNotesPage({required this.subjectData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notes - ${subjectData.subjectName}',
          style: GoogleFonts.adamina(),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 158, 37, 160).withOpacity(0.3),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple.shade200, Colors.pink.shade200],
          ),
        ),
        child: Center(
          child: Text(
            'Add notes for ${subjectData.subjectName} here',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}

class SetReminderPage extends StatelessWidget {
  final SubjectData subjectData;

  SetReminderPage({required this.subjectData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Set Reminder - ${subjectData.subjectName}',
          style: GoogleFonts.adamina(),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 158, 37, 160).withOpacity(0.3),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple.shade200, Colors.pink.shade200],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Handle assignment reminder
                },
                child: Text(
                  'Assignment Reminder',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Handle exam reminder
                },
                child: Text(
                  'Exam Reminder',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Handle general reminder
                },
                child: Text(
                  'Reminder',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
