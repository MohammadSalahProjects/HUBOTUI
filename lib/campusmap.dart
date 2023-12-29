import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  final LatLng _universityLocation =
      const LatLng(32.0995480065019, 36.1909090670292);
  // Replace YOUR_LATITUDE and YOUR_LONGITUDE with your university's coordinates

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('University Map'),
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: _universityLocation,
          zoom: 15.0,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('University'),
            position: _universityLocation,
            infoWindow: const InfoWindow(title: 'Your University'),
          ),
        },
      ),
    );
  }
}
