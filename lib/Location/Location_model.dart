class Location_Model {
  final String placeName;
  final String placeType;
  final double latitude;
  final double longitude;

  Location_Model({
    required this.placeName,
    required this.placeType,
    required this.latitude,
    required this.longitude,
  });

  factory Location_Model.fromJson(Map<String, dynamic> json) {
    return Location_Model(
      placeName: json['placeName'],
      placeType: json['placeType'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}