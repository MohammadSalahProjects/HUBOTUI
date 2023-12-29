// ignore_for_file: unnecessary_const

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  var markersOnMap = HashSet<Marker>();
  MapType _currentMapType = MapType.normal; // Default map type

  static const LatLng _universityLocation =
      LatLng(32.0995480065019, 36.1909090670292);

  Set<Circle> circles = Set.from([
    const Circle(
      circleId: const CircleId('HUFocusCircl'),
      center: LatLng(32.10101412124145, 36.18650692941451),
      radius: 1000,
      strokeWidth: 1,
      fillColor: Color.fromARGB(80, 169, 228, 225),
    )
  ]);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('University Map'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
              setState(() {
                markersOnMap.add(
                  const Marker(
                    markerId: MarkerId('University'),
                    position: _universityLocation,
                    infoWindow: InfoWindow(
                      title: 'Your University',
                      snippet: "mohammad salah",
                    ),
                    icon: BitmapDescriptor.defaultMarker,
                  ),
                );
              });
            },
            initialCameraPosition: const CameraPosition(
              target: _universityLocation,
              zoom: 15.0,
            ),
            markers: markersOnMap,
            mapType: _currentMapType,
            circles: circles,
          ),
          Positioned(
            top: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () {
                _toggleMapType();
              },
              child: const Icon(Icons.layers),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleMapType() {
    setState(() {
      _currentMapType =
          _currentMapType == MapType.normal ? MapType.hybrid : MapType.normal;
    });
  }
}
