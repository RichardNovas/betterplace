import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class MapTwo extends StatefulWidget {
  MapTwo({@required this.title, this.toggleView});
  final Function toggleView;

  final String title;

  @override
  State<MapTwo> createState() => MapTwoState();
}

class MapTwoState extends State<MapTwo> {
  final Firestore _database = Firestore.instance;
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  void initState() {
    crearmarcadores();
    super.initState();
  }

  crearmarcadores() {
    _database
        .collectionGroup('posts')
        .where('role', isEqualTo: 'Request')
        .getDocuments()
        .then((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i = 0; i < docs.documents.length; i++) {
          initMarker(docs.documents[i].data, docs.documents[i].documentID);
        }
      }
    });
  }

  void initMarker(request, requestesid) {
    var markerIdVal = requestesid;
    final MarkerId markerId = MarkerId(markerIdVal);

    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position:
          LatLng(request['location'].latitude, request['location'].longitude),
      infoWindow: InfoWindow(
          title: 'Better Place'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed),
      onTap: () {
        return showModalBottomSheet(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
            isDismissible: true,
            isScrollControlled: true,
            enableDrag: true,
            backgroundColor: Colors.transparent,
            context: context,
            useRootNavigator: true,
            builder: (context) {
               DateTime myDateTime = (request['createdOn'])
                                    .toDate();
              return Container(
                height: MediaQuery.of(context).size.height * 0.70,
                child: Scaffold(
                    backgroundColor: Colors.transparent,
                    resizeToAvoidBottomInset: true,
                    body: SingleChildScrollView(
                                          child:Column(
                                            
                                            children: <Widget>[
                                              SizedBox(height: 20,),
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                child: Card(
                                                  elevation: 30,
                                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  color: Color.fromARGB(255, 30, 55, 91),
                                  child: Container(
                                   
                                    padding: EdgeInsets.fromLTRB(25, 15, 25, 15),
                                    child: Text('Requesting',style: TextStyle(color: Colors.white))),
                                                ),
                                              ),
                                              SizedBox(height: 10,),
                                              Card(
                                                 elevation: 30,
                                                shadowColor: Colors.grey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  color: Colors.white,
                                              child:Column(
                                    children: <Widget>[
                                      SizedBox(height: 10,),
                                       ListTile(
                                        
                                        leading: Container(
                                          width: 45,
                                          height: 45,
                                          child: CircleAvatar(
                                            radius: 30.0,
                                            backgroundImage: AssetImage(
                                                'assets/images/bb.png'),
                                            backgroundColor: Colors.transparent,
                                          ),
                                        ),
                                      
                                        title:Text(
                                                          '\n${request['name'] as String}',
                                                          style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    30,
                                                                    55,
                                                                    91),
                                                            fontSize: 17.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                        subtitle: Text(
                                          '$myDateTime',
                                          style: TextStyle(fontSize: 9),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            30, 8, 30, 8),
                                        child: Container(
                                          alignment: Alignment.topLeft,
                                          child:Text(
                                            '${request['item'] as String} for ${request['foodCount'] as String}',
                                            style: TextStyle(
                                              color: Colors.black,
                                              
                                              fontWeight: FontWeight.w600,
                                            )),
                                        ),
                                      ),
                                       
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            30, 8, 30, 8),
                                        child: Container(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            '${request['Address'] as String}',
                                           
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20,),
                                      ButtonBar(
                                        alignment: MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              launch(
                                                  ('tel:// ${request['Phone'] as String}'));
                                            },
                                            icon: Icon(
                                              Icons.phone,
                                              color:  Color.fromARGB(255, 30, 55, 91),
                                            ),
                                          ),
                                         
                                          
                                        ],
                                      ),
                                      
                                    ],
                                    
                                  ),
                                              ),
                                              SizedBox(height: 30,) ],
                                          )
                    )));
            });
      },
    );

    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
    });
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(13.688841, 80.44015),
    zoom: 5,
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: GoogleMap(
          mapType: MapType.normal,
          zoomControlsEnabled: false,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: Set<Marker>.of(markers.values),
         myLocationButtonEnabled: false,
          myLocationEnabled: true,
        ),
        floatingActionButton: Stack(children: <Widget>[
          Padding(padding: EdgeInsets.only(left:31),
           child:Align(
             alignment: Alignment.bottomLeft,
                        child: FloatingActionButton(
              onPressed: _currentLocation,
              child: Icon(
                Icons.my_location,
                color: Colors.black54,
              ),
              backgroundColor: Colors.white,
          ),
           ),),
            Padding(padding: EdgeInsets.only(top:31),
           child:Align(
             alignment: Alignment.topRight,
                        child: FloatingActionButton.extended(
              onPressed: () {
                widget.toggleView();
              },
              label: Row(
      children: <Widget>[Text('Show Contributors',style: TextStyle(color: Colors.white,fontSize: 13),), ],
    ),
   
  
              
              backgroundColor: Color.fromARGB(255, 30, 55, 91),
          ),
           ),)
        ]));
  }

  void _currentLocation() async {
    final GoogleMapController controller = await _controller.future;
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
   Stream<QuerySnapshot> getUsersdocumentStreamSnapshots(
      BuildContext context) async* {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser user = await _auth.currentUser();
    yield* Firestore.instance
        .collection("users")
        .document(user.uid)
        .collection("Email Registration")
        .snapshots();
  }
}
