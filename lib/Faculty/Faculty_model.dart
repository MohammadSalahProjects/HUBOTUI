import 'package:hubot/Building/Building.dart';

class Faculty {
  final String facultyId;
  final Building building;
  final String facultyName;
  final int facultyLocationId;
  final String keyword;
  final String description;
  final int floor;

  Faculty({
    required this.facultyId,
    required this.building,
    required this.facultyName,
    required this.facultyLocationId,
    required this.keyword,
    required this.description,
    required this.floor,
  });

  factory Faculty.fromJson(Map<String, dynamic> json) {
    return Faculty(
      facultyId: json['facultyId'],
      building: Building.fromJson(json['building']),
      facultyName: json['facultyName'],
      facultyLocationId: json['facultyLocationId'],
      keyword: json['keyword'],
      description: json['description'],
      floor: json['floor'],
    );
  }
}
