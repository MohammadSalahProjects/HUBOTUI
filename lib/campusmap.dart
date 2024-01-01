// ignore_for_file: unnecessary_const

import 'dart:async';
import 'dart:collection';

import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapScreen extends StatefulWidget {
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Location _locationController = new Location();
  static const LatLng _pGooglePlex = LatLng(32.10304182954006, 36.18674055587614);
  static const LatLng _southGate = LatLng(32.10019273091038, 36.19006874105625);
  static const LatLng _ammanBusStop = LatLng(32.099159840483985, 36.19010615822166);
  static const LatLng _hussainBanyBuilding = LatLng(32.10034491821601, 36.18926208864537);
  static const LatLng zink = LatLng(32.10043150399373, 36.18884537762494);
  static const LatLng _architectuerEnginiering = LatLng(32.09988534617556, 36.18861736593452);
  static const LatLng _itFaculty = LatLng(32.10004430110536, 36.18606628152662);

  LatLng? _currentP = null;

  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();

  @override
  initState(){
    super.initState();
    getLocationUpdates();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: _currentP == null ? const Center(
        child: Text("loading"),
      )
          :GoogleMap(
        onMapCreated: ((GoogleMapController controller)
            => _mapController.complete(controller)),
        initialCameraPosition: CameraPosition(target: _pGooglePlex, zoom: 23),
      markers: {
        Marker(
            markerId: MarkerId("currentLoacation"),
            icon: BitmapDescriptor.defaultMarker,
            position: _currentP!),
        Marker(
        markerId: MarkerId("_sourceLoaction"),
        icon: BitmapDescriptor.defaultMarker,
        position: _pGooglePlex),
        Marker(
        markerId: MarkerId("_ITFaculty"),
        icon: BitmapDescriptor.defaultMarker,
        position: _itFaculty)
        },
      ),
    );

  }

  Future<void> cameraToPosition(LatLng pos) async{
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(
        target: pos,
      zoom: 20
    );
    await controller.animateCamera(CameraUpdate.newCameraPosition(_newCameraPosition),
    );
  }
  Future<void> getLocationUpdates() async{
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();

    if(_serviceEnabled){
      _serviceEnabled = await _locationController.requestService();
    }else{
      return;
    }
    _permissionGranted =  await _locationController.hasPermission();
    if(_permissionGranted == PermissionStatus.denied){
      _permissionGranted = await _locationController.requestPermission();
      if(_permissionGranted != PermissionStatus.granted){
        return;
      }
    }
    _locationController.onLocationChanged.listen((LocationData currentLocation) {
      if(currentLocation.latitude != null && currentLocation.longitude != null){
        setState(() {
          _currentP = LatLng(currentLocation.latitude!, currentLocation.longitude!);
        });
        cameraToPosition(_currentP!);
      }
    });
  }
  // Future<List<LatLng>> getPolyPoints() async {
  //   List<LatLng> polyLineCoordinates = [];
  //   PolylinePoints polylinePoints = PolylinePoints();
  //   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(googleApiKey, origin, destination);
  //
  // }
 }

