import '../Department/Department_model.dart';

class Major {
  final String id;
  final Department department;
  final String name;

  Major({
    required this.id,
    required this.department,
    required this.name,
  });

  factory Major.fromJson(Map<String, dynamic> json) {
    return Major(
      id: json['majorId'] as String,
      department:
          Department.fromJson(json['department'] as Map<String, dynamic>),
      name: json['majorName'] as String,
    );
  }
}
