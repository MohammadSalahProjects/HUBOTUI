import '../Faculty/Faculty_model.dart';

class Department {
  final String id;
  final String name;
  final String keyword;
  final String description;
  final int departmentLocationId;
  final int floor;
  final Faculty faculty;

  Department({
    required this.id,
    required this.name,
    required this.keyword,
    required this.description,
    required this.departmentLocationId,
    required this.floor,
    required this.faculty,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['departmentId'] as String,
      name: json['departmentName'] as String,
      keyword: json['keyword'] as String,
      description: json['description'] as String,
      departmentLocationId: json['departmentLocationId'] as int,
      floor: json['floor'] as int,
      faculty: Faculty.fromJson(json['faculty'] as Map<String, dynamic>),
    );
  }
}
