import 'package:hubot/Department/Department_model.dart';
import 'package:hubot/User/User.dart'; // Replace with appropriate User class path

enum Gender { male, female }

class Student {
  String id;
  User user;
  Department department;
  String firstName;
  String middleName;
  String lastName;
  String email;
  Gender gender;

  Student({
    required this.id,
    required this.user,
    required this.department,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.email,
    required this.gender,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      user: User.fromJson(json['user']), // Implement User.fromJson accordingly
      department: Department.fromJson(
          json['department']), // Implement Department.fromJson accordingly
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      email: json['email'],
      gender: json['gender'] == 'male' ? Gender.male : Gender.female,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(), // Implement User.toJson accordingly
      'department':
          department.toJson(), // Implement Department.toJson accordingly
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'email': email,
      'gender': gender == Gender.male ? 'male' : 'female',
    };
  }
}
