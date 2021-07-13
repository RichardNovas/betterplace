import 'dart:async';
import 'package:betterplace/services/crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class NewPost extends StatefulWidget {
  @override
  State<NewPost> createState() => MyMapSampleState();
}

class MyMapSampleState extends State<NewPost> {
  Completer<GoogleMapController> _controller = Completer();

  final _formKey = GlobalKey<FormState>();

  List<Marker> myMarker = [];

  double latitude;

  double longitude;

  LatLng tappedPoint;

  var tappedLocation;
  String name;
  String foodCount;
  String address;
  String phone;
  String role;

  CrudMedthods crudObj = new CrudMedthods();

  String item;
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(13.688841, 80.44015),
                zoom: 5,
              ),
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              onTap: (tappedPoint) {
                print(tappedPoint);

                setState(() {
                  tappedLocation = tappedPoint;

                  myMarker = [];

                  myMarker.add(
                    Marker(
                      markerId: MarkerId(tappedPoint.toString()),
                      position: tappedPoint,
                      draggable: false,
                    ),
                  );
                });
              },
              markers: Set.from(myMarker),
            ),
          ],
        ),
        floatingActionButton: Stack(children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 31),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton(
                onPressed: _currentLocation,
                child: Icon(
                  Icons.my_location,
                  color: Colors.black54,
                ),
                backgroundColor: Colors.white,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton.extended(
                label: Text('Next'),
                backgroundColor: Color.fromARGB(255, 30, 55, 91),
                onPressed: () {
                  if (tappedLocation == null) {
                    return showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            contentPadding: EdgeInsets.all(15),
                            content: Container(
                              height: 90,
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    'Please mark the location!',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Icon(
                                    Icons.location_on,
                                    size: 40,
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  } else {
                    return showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(30))),
                        isDismissible: true,
                        isScrollControlled: true,
                        enableDrag: true,
                        backgroundColor: Colors.white,
                        context: context,
                        useRootNavigator: true,
                        builder: (context) => Container(
                              height: MediaQuery.of(context).size.height * 0.95,
                              child: Scaffold(
                                backgroundColor: Colors.transparent,
                                resizeToAvoidBottomInset: true,
                                body: Container(
                                  child: Form(
                                      key: _formKey,
                                      child: SingleChildScrollView(
                                        child: Container(
                                          padding: EdgeInsets.all(20),
                                          child: Column(children: <Widget>[
                                            SizedBox(
                                              height: 30,
                                            ),
                                            TextFormField(
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'Name',
                                                isDense: true,
                                              ),
                                              keyboardType: TextInputType.name,
                                              onChanged: (value) {
                                                this.name = value;
                                              },
                                            ),
                                            SizedBox(height: 20.0),
                                            DropdownButtonFormField<String>(
                                                items: <String>[
                                                  'Contribute',
                                                  'Request'
                                                ]
                                                    .map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (String value) =>
                                                            DropdownMenuItem<
                                                                String>(
                                                              child:
                                                                  Text(value),
                                                              value: value,
                                                            ))
                                                    .toList(),
                                                hint: Text('Choose your Role'),
                                                validator: (value) {
                                                  if (value.isEmpty) {
                                                    return 'Select your Role';
                                                  }
                                                  return null;
                                                },
                                                onChanged: (String value) {
                                                  setState(() {
                                                    this.role = value;
                                                  });
                                                }),
                                            SizedBox(height: 20.0),
                                            DropdownButtonFormField<String>(
                                                items: <String>[
                                                  'Food',
                                                  'Clothes',
                                                  'Food & Clothes'
                                                ]
                                                    .map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (String value) =>
                                                            DropdownMenuItem<
                                                                String>(
                                                              child:
                                                                  Text(value),
                                                              value: value,
                                                            ))
                                                    .toList(),
                                                hint: Text('Select'),
                                                validator: (value) {
                                                  if (value.isEmpty) {
                                                    return 'Select ';
                                                  }
                                                  return null;
                                                },
                                                onChanged: (String value) {
                                                  setState(() {
                                                    this.item = value;
                                                  });
                                                }),
                                            SizedBox(height: 20.0),
                                            TextFormField(
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'Count',
                                                isDense: true,
                                              ),
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  return 'Please enter Food Count';
                                                }
                                                return null;
                                              },
                                              keyboardType:
                                                  TextInputType.number,
                                              onChanged: (value) {
                                                this.foodCount = value;
                                              },
                                            ),
                                            SizedBox(height: 20.0),
                                            SizedBox(height: 20.0),
                                            TextFormField(
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'Add Description',
                                                isDense: true,
                                              ),
                                              keyboardType:
                                                  TextInputType.multiline,
                                              textInputAction:
                                                  TextInputAction.newline,
                                              maxLines: 4,
                                              maxLength: 1500,
                                              buildCounter:
                                                  (BuildContext context,
                                                          {int currentLength,
                                                          int maxLength,
                                                          bool isFocused}) =>
                                                      null,
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  return 'Enter your address/description';
                                                }
                                                return null;
                                              },
                                              onChanged: (value) {
                                                this.address = value;
                                              },
                                            ),
                                            SizedBox(height: 20.0),
                                            TextFormField(
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'Phone',
                                                isDense: true,
                                              ),
                                              keyboardType: TextInputType.phone,
                                              onChanged: (value) {
                                                this.phone = value;
                                              },
                                            ),
                                            SizedBox(height: 20.0),
                                            SizedBox(
                                              height: 20.0,
                                            ),
                                            RaisedButton(
                                              onPressed: () async {
                                                if (_formKey.currentState
                                                    .validate()) {
                                                  final FirebaseAuth _auth =
                                                      FirebaseAuth.instance;
                                                  FirebaseUser user =
                                                      await _auth.currentUser();
                                                  Firestore.instance
                                                      .collection('users')
                                                      .document(user.uid)
                                                      .collection('posts')
                                                      .document()
                                                      .setData({
                                                    'name': this.name,
                                                    'role': this.role,
                                                    'item': this.item,
                                                    'foodCount': this.foodCount,
                                                    'createdOn': FieldValue
                                                        .serverTimestamp(),
                                                    'Address': this.address,
                                                    'Phone': this.phone,
                                                    'location': GeoPoint(
                                                        tappedLocation.latitude,
                                                        tappedLocation
                                                            .longitude)
                                                  }).catchError((e) {
                                                    print(e);
                                                  }).whenComplete(
                                                    () => showDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            false,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title:
                                                                Text('Posted!'),
                                                            actions: <Widget>[
                                                              new FlatButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator
                                                                        .pushNamedAndRemoveUntil(
                                                                      context,
                                                                      ('/navigate'),
                                                                      (Route<dynamic>
                                                                              route) =>
                                                                          false,
                                                                    );
                                                                  },
                                                                  child: Text(
                                                                      'Okay')),
                                                            ],
                                                          );
                                                        }),
                                                  );
                                                }
                                              },
                                              textColor: Colors.white,
                                              color: Colors.transparent,
                                              padding: EdgeInsets.all(0),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  gradient: LinearGradient(
                                                    colors: <Color>[
                                                      Color.fromARGB(
                                                          255, 30, 55, 91),
                                                      Colors.black,
                                                    ],
                                                  ),
                                                ),
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        50, 15, 50, 15),
                                                child: Text(
                                                  'Post',
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 50.0,
                                            ),
                                            Center(
                                              child: Column(
                                                children: <Widget>[
                                                  Text(
                                                    'From',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12),
                                                  ),
                                                  Text(
                                                    'feelpurposed.com',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  )
                                                ],
                                              ),
                                            )
                                          ]),
                                        ),
                                      )),
                                ),
                              ),
                            ));
                  }
                }),
          )
        ]));
  }
}
