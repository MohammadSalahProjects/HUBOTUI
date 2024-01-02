import 'package:flutter/foundation.dart';

class Building {
  final String buildingId;
  final String buildingName;
  final Location location;
  final String description;
  final String keyword;
  final DateTime addedDate;

  Building({
    required this.buildingId,
    required this.buildingName,
    required this.location,
    required this.description,
    required this.keyword,
    required this.addedDate,
  });

  factory Building.fromJson(Map<String, dynamic> json) {
    return Building(
      buildingId: json['buildingId'],
      buildingName: json['buildingName'],
      location: Location.fromJson(json['location']),
      description: json['description'],
      keyword: json['keyword'],
      addedDate: DateTime.parse(json['addedDate']),
    );
  }
}

class Location {
  final double latitude;
  final double longitude;

  Location({
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
