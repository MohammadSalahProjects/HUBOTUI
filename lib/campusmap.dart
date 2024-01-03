import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hubot/Location/Location_model.dart';
import 'package:location/location.dart';
import 'package:location/location.dart' as loc;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' show cos, sqrt, asin;

import 'Directions_model.dart';
import 'package:hubot/dirictionRepository.dart';
import 'consts.dart';

class MapScreen extends StatefulWidget {
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Location _locationController = Location();
  DirectionRepository _directionRepository = DirectionRepository(dio: Dio());


  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();

  static const LatLng _pGooglePlex = LatLng(37.4223, -122.0848);
  static const LatLng _pApplePark = LatLng(37.3346, -122.0090);
  LatLng? _currentP;
  LatLng? selectedDestination;

  late Directions _info;

  Map<PolylineId, Polyline> polylines = {};

  List<Location_Model> faculties = [];
  List<Location_Model> departments = [];
  List<Location_Model> buildings = [];
  List<Location_Model> restaurants = [];



  @override
  void initState() {
    super.initState();
    fetchData();
    getLocationUpdates();
  }
  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('https://768f-2a01-9700-1a9a-7800-5b0-d5cd-7f59-3613.ngrok-free.app/locations/placesByType'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        faculties = (data['FACULTY'] as List).map((e) => Location_Model.fromJson(e)).toList();
        departments = (data['DEPARTMENTS'] as List).map((e) => Location_Model.fromJson(e)).toList();
        buildings = (data['BUILDING'] as List).map((e) => Location_Model.fromJson(e)).toList();
        restaurants = (data['RESTAURANT'] as List).map((e) => Location_Model.fromJson(e)).toList();
        setState(() {});
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print(error);
      // Handle error
    }
  }

  Future<List<double>?> getLocationCoordinates(String placeName) async {
    try {
      final response = await http.get(Uri.parse('https://768f-2a01-9700-1a9a-7800-5b0-d5cd-7f59-3613.ngrok-free.app/locations/getLocationByPlaceName?placeName=$placeName'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return List<double>.from(data);
      } else {
        throw Exception('Failed to get location coordinates');
      }
    } catch (error) {
      print(error);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Location_Model> allLocations = [...faculties, ...departments, ...buildings, ...restaurants];

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Place'),
      ),
      body: Center(
        child: Column(
          children: [
            DropdownButton<Location_Model>(
              value: null,
              hint: Text('Select Place'),
            onChanged: (Location_Model? newValue) async {
              if (newValue != null) {
                final List<double>? coordinates = await getLocationCoordinates(newValue.placeName);
                if (coordinates != null && coordinates.length == 2) {
                  setState(() {
                    selectedDestination = LatLng(coordinates[0], coordinates[1]);
                  });
                  _cameraToPosition(selectedDestination!);
                  if (_currentP != null && selectedDestination != null) {
                    _drawRoute(_currentP!, selectedDestination!); // Pass the source and destination coordinates
                  }
                }
              }
            },
              items: allLocations.map((Location_Model location) {
                return DropdownMenuItem<Location_Model>(
                  value: location,
                  child: Text(location.placeName),
                );
              }).toList(),
            ),

            Expanded(
              child: _currentP == null
                  ? Center(child: Text("Loading..."))
                  : GoogleMap(
                onMapCreated: ((GoogleMapController controller) => _mapController.complete(controller)),
                initialCameraPosition: CameraPosition(
                  target: _pGooglePlex,
                  zoom: 5,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId("_currentLocation"),
                    icon: BitmapDescriptor.defaultMarker,
                    position: _currentP!,
                  ),
                  if (selectedDestination != null)
                    Marker(
                      markerId: MarkerId("_destinationLocation"),
                      icon: BitmapDescriptor.defaultMarker,
                      position: selectedDestination!,
                    ),
                },

                polylines: Set<Polyline>.of(polylines.values),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToDestination() async {
    if (_currentP != null && selectedDestination != null) {
      _drawRoute(_currentP!, selectedDestination!);
    }
  }

  void _drawRoute(LatLng source, LatLng destination) async {
    try {
      Directions? directions = await _directionRepository.getDirections(
        currentP: source,
        destination: destination,
      );

      if (directions != null) {
        setState(() {
          _info = directions;
        });

        generatePolyLineFromPoints(directions.polylinepoints.map((point) =>
            LatLng(point.latitude, point.longitude)).toList());
      }
    } catch (e) {
      print('Error fetching directions: $e');
    }
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(
      target: pos,
      zoom: 13,
    );
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(_newCameraPosition),
    );
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _currentP =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          _cameraToPosition(_currentP!);
        });
      }
    });
  }

  Future<List<LatLng>> getPolylinePoints(LatLng source, LatLng destination) async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      GOOGLE_MAPS_API_KEY,
      PointLatLng(source.latitude, source.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    return polylineCoordinates;
  }

  void generatePolyLineFromPoints(List<LatLng> polylineCoordinates) async {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.black,
      points: polylineCoordinates,
      width: 8,
    );
    setState(() {
      polylines[id] = polyline;
    });
  }

}
