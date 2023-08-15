import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum Gender {
  Male,
  Female,
}

class Faculty {
  final String id;
  final String name;
  final String keyword;
  final String description;
  final int facultyLocationId;
  final int floor;

  Faculty({
    required this.id,
    required this.name,
    required this.keyword,
    required this.description,
    required this.facultyLocationId,
    required this.floor,
  });

  factory Faculty.fromJson(Map<String, dynamic> json) {
    return Faculty(
      id: json['facultyId'] as String,
      name: json['facultyName'] as String,
      keyword: json['keyword'] as String,
      description: json['description'] as String,
      facultyLocationId: json['facultyLocationId'] as int,
      floor: json['floor'] as int,
    );
  }
}
