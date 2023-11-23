import 'package:hubot/Faculty/Faculty_model.dart';

class Department {
  final String departmentId;
  final Faculty faculty;
  final String departmentName;
  final int departmentLocationId;
  final String keyword;
  final String description;
  final int floor;

  Department({
    required this.departmentId,
    required this.faculty,
    required this.departmentName,
    required this.departmentLocationId,
    required this.keyword,
    required this.description,
    required this.floor,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      departmentId: json['departmentId'],
      faculty: Faculty.fromJson(json['faculty']),
      departmentName: json['departmentName'],
      departmentLocationId: json['departmentLocationId'],
      keyword: json['keyword'],
      description: json['description'],
      floor: json['floor'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'departmentId': departmentId,
      'faculty': faculty,
      'departmentName': departmentName,
      'departmentLocationId': departmentLocationId,
      'keyword': keyword, // Uncomment if needed
      'description': description,
      'floor': floor,
    };
  }
}
