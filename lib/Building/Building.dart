class Building {
  final String buildingId;
  final String buildingName;
  final int locationId;
  final String description;
  final String keyword;
  final DateTime addedDate;

  Building({
    required this.buildingId,
    required this.buildingName,
    required this.locationId,
    required this.description,
    required this.keyword,
    required this.addedDate,
  });

  factory Building.fromJson(Map<String, dynamic> json) {
    return Building(
      buildingId: json['buildingId'],
      buildingName: json['buildingName'],
      locationId: json['locationId'],
      description: json['description'],
      keyword: json['keyword'],
      addedDate: DateTime.parse(json['addedDate']),
    );
  }
}
