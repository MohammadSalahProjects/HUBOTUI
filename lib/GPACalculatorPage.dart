import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'slide_menu.dart';
import 'chatbot_page.dart';

class GPACalculatorPage extends StatefulWidget {
  @override
  _GPACalculatorPageState createState() => _GPACalculatorPageState();
}

class _GPACalculatorPageState extends State<GPACalculatorPage> {
  final _formKey = GlobalKey<FormState>();
  final _creditHoursController = TextEditingController();
  final _previousGPAController = TextEditingController();
  List<SubjectData> _subjectDataList = [];

  double _calculateGPA() {
    double totalGradePoints = 0;
    int totalCreditHours = 0;

    for (var subjectData in _subjectDataList) {
      totalGradePoints += subjectData.creditHours * subjectData.gradePoints;
      totalCreditHours += subjectData.creditHours;
    }

    if (totalCreditHours > 0) {
      return totalGradePoints / totalCreditHours;
    } else {
      return 0;
    }
  }

  void _showResultDialog(double gpa) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('GPA Calculation Result'),
          content: Text('Your GPA is: ${gpa.toStringAsFixed(2)}'),
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

  void _addSubjectData(SubjectData subjectData) {
    setState(() {
      _subjectDataList.add(subjectData);
    });
  }

  @override
  void dispose() {
    _creditHoursController.dispose();
    _previousGPAController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'GPA Calculator',
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
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _previousGPAController,
                  decoration: InputDecoration(
                    labelText: 'Previous GPA',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the previous GPA';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid GPA';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _creditHoursController,
                  decoration: InputDecoration(
                    labelText: 'Earned Credit Hours',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the earned credit hours';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid credit hours';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0),
                Text(
                  'Subjects',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _subjectDataList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('Subject ${index + 1}'),
                      subtitle: Text(
                        'Credit Hours: ${_subjectDataList[index].creditHours}, Grade: ${_subjectDataList[index].grade}',
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return SubjectInputDialog(
                          onSubjectDataSubmitted: _addSubjectData,
                        );
                      },
                    );
                  },
                  child: const Text('Add Subject'),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      double previousGPA =
                          double.parse(_previousGPAController.text);
                      int earnedCreditHours =
                          int.parse(_creditHoursController.text);

                      double gpa = _calculateGPA();

                      _showResultDialog(gpa);
                    }
                  },
                  child: Text('Calculate GPA'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SubjectData {
  final int creditHours;
  final String grade;
  final double gradePoints;
  final bool isRepeated;

  SubjectData({
    required this.creditHours,
    required this.grade,
    required this.gradePoints,
    required this.isRepeated,
  });
}

class SubjectInputDialog extends StatefulWidget {
  final Function(SubjectData) onSubjectDataSubmitted;

  SubjectInputDialog({required this.onSubjectDataSubmitted});

  @override
  _SubjectInputDialogState createState() => _SubjectInputDialogState();
}

class _SubjectInputDialogState extends State<SubjectInputDialog> {
  final _creditHoursController = TextEditingController();
  final _gradeController = TextEditingController();
  bool _isRepeated = false;

  @override
  void dispose() {
    _creditHoursController.dispose();
    _gradeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Subject'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _creditHoursController,
            decoration: InputDecoration(
              labelText: 'Credit Hours',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter the credit hours';
              }
              if (int.tryParse(value) == null) {
                return 'Please enter a valid credit hours';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _gradeController,
            decoration: InputDecoration(
              labelText: 'Grade',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter the grade';
              }
              // Add any custom validation for grade here if needed
              return null;
            },
          ),
          Row(
            children: [
              Checkbox(
                value: _isRepeated,
                onChanged: (value) {
                  setState(() {
                    _isRepeated = value!;
                  });
                },
              ),
              Text('Repeated Subject'),
            ],
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
        ElevatedButton(
          onPressed: () {
            if (_creditHoursController.text.isNotEmpty &&
                _gradeController.text.isNotEmpty) {
              int creditHours = int.parse(_creditHoursController.text);
              String grade = _gradeController.text;
              double gradePoints = _calculateGradePoints(grade);

              SubjectData subjectData = SubjectData(
                creditHours: creditHours,
                grade: grade,
                gradePoints: gradePoints,
                isRepeated: _isRepeated,
              );

              widget.onSubjectDataSubmitted(subjectData);
              Navigator.pop(context);
            }
          },
          child: Text('Add'),
        ),
      ],
    );
  }

  double _calculateGradePoints(String grade) {
    switch (grade) {
      case 'A+':
        return 4.0;
      case 'A':
        return 3.5;
      case 'A-':
        return 3.0;
      case 'B+':
        return 2.5;
      case 'B':
        return 2.0;
      case 'B-':
        return 1.5;
      case 'C+':
        return 1.0;
      case 'C':
        return 0.5;
      default:
        return 0.0;
    }
  }
}
