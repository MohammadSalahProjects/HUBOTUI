import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GPACalculatorPage(),
    );
  }
}

class GPACalculatorPage extends StatefulWidget {
  @override
  _GPACalculatorPageState createState() => _GPACalculatorPageState();
}

class _GPACalculatorPageState extends State<GPACalculatorPage> {
  final _formKey = GlobalKey<FormState>();
  final _previousPassedHoursController = TextEditingController(text: '0');
  final _previousGPAController = TextEditingController(text: '0');
  List<SubjectData> _subjectDataList = [];

  double _calculateGPA() {
    double totalGradePoints = 0;
    int totalCreditHours = 0;

    for (var subjectData in _subjectDataList) {
      totalGradePoints += subjectData.creditHours * subjectData.gradePoints;
      totalCreditHours += subjectData.creditHours;
    }

    int previousPassedHours = int.parse(_previousPassedHoursController.text);
    double previousGPA = double.parse(_previousGPAController.text);

    if (previousPassedHours > 0) {
      totalGradePoints += previousPassedHours * previousGPA;
      totalCreditHours += previousPassedHours;
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
          title: const Text('GPA Calculation Result'),
          content: Text('Your GPA is: ${gpa.toStringAsFixed(2)}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
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
    _previousPassedHoursController.dispose();
    _previousGPAController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GPA Calculator'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _previousPassedHoursController,
                  decoration: const InputDecoration(
                    labelText: 'Previous Passed Hours',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the previous passed hours';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _previousGPAController,
                  decoration: const InputDecoration(
                    labelText: 'Previous GPA',
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
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
                const SizedBox(height: 20.0),
                const Text(
                  'Subjects',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10.0),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
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
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      double gpa = _calculateGPA();
                      _showResultDialog(gpa);
                    }
                  },
                  child: const Text('Calculate GPA'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _previousPassedHoursController.text = '0';
                      _previousGPAController.text = '0';
                      _subjectDataList.clear();
                    });
                  },
                  child: const Text('Clear'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SubjectInputDialog extends StatefulWidget {
  final Function(SubjectData) onSubjectDataSubmitted;

  SubjectInputDialog({required this.onSubjectDataSubmitted});

  @override
  _SubjectInputDialogState createState() => _SubjectInputDialogState();
}

class _SubjectInputDialogState extends State<SubjectInputDialog> {
  final _creditHoursController = TextEditingController();
  String _selectedGrade = 'A+';
  bool _isRepeated = false;

  @override
  void dispose() {
    _creditHoursController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Subject'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _creditHoursController,
            decoration: const InputDecoration(
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
          DropdownButtonFormField<String>(
            value: _selectedGrade,
            onChanged: (newValue) {
              setState(() {
                _selectedGrade = newValue!;
              });
            },
            items: <String>[
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
              'F'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            decoration: const InputDecoration(
              labelText: 'Grade',
            ),
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
              const Text('Repeated Subject'),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_creditHoursController.text.isNotEmpty) {
              int creditHours = int.parse(_creditHoursController.text);
              double gradePoints = _calculateGradePoints(_selectedGrade);

              SubjectData subjectData = SubjectData(
                creditHours: creditHours,
                grade: _selectedGrade,
                gradePoints: gradePoints,
                isRepeated: _isRepeated,
              );

              widget.onSubjectDataSubmitted(subjectData);
              Navigator.pop(context);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }

  double _calculateGradePoints(String grade) {
    switch (grade) {
      case 'A+':
        return 4.0;
      case 'A':
        return 3.75;
      case 'A-':
        return 3.5;
      case 'B+':
        return 3.25;
      case 'B':
        return 3.0;
      case 'B-':
        return 2.75;
      case 'C+':
        return 2.5;
      case 'C':
        return 2.25;
      case 'C-':
        return 2.0;
      case 'D+':
        return 1.75;
      case 'D':
        return 1.5;
      case 'F':
        return 0.0;
      default:
        return 0.0;
    }
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
