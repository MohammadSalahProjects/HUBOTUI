import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:hubot/consts.dart';

import 'Directions_model.dart';



class DirectionRepository{
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';

  final Dio _dio;

  DirectionRepository({required Dio dio}) : _dio = dio ?? Dio();

  Future<Directions?> getDirections({
    required LatLng currentP,
    required LatLng destination,
  }) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'origin': '${currentP.latitude},${currentP.longitude}',
          'destination': '${destination.latitude},${destination.longitude}',
          'key': GOOGLE_MAPS_API_KEY,
        },
      );

      if (response.statusCode == 200) {
        return Directions.fromMap(response.data);
      }
    } catch (error) {
      print('Error fetching directions: $error');
    }

    return null;
  }


}