import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class IndividualMap extends StatefulWidget {

  IndividualMap({@required this.lat,@required this.lng,});
  final double lat;
  final double lng;


  @override
  _IndividualMapState createState() => _IndividualMapState();
}

class _IndividualMapState extends State<IndividualMap> {

  final Completer<GoogleMapController> _mapController = Completer();
  List<Marker> marker = [];
  
   void _currentLocation() async {
    final GoogleMapController controller = await _mapController.future;
    LocationData currentLocation;
    var location = new Location();
    try {
      currentLocation = await location.getLocation();
    } on Exception {
      currentLocation = null;
    }

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 18.0,
      ),
    ));
  }
  
  @override
  Widget build(BuildContext context) {marker.add(Marker(
        markerId: MarkerId('SomeId'),
        position: LatLng(
          widget.lat,widget.lng ),
        ));
    return Scaffold(
      floatingActionButton: FloatingActionButton(
              onPressed: _currentLocation,
              child: Icon(
                Icons.my_location,
                color: Colors.black54,
              ),
              backgroundColor: Colors.white,
          ),
      body: Container(
        
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: LatLng(
          widget.lat,widget.lng ),
            zoom: 14,
          ),
         
          myLocationButtonEnabled: false,
          myLocationEnabled: true,
          zoomControlsEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            _mapController.complete(controller);
          },
          markers: Set<Marker>.of(marker),
        ),
      ),
    );
    
  }
}
