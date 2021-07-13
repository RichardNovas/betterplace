import 'dart:async';
import 'package:betterplace/screens/home/navigation_view/individualMap.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:betterplace/services/crud.dart';
import 'package:url_launcher/url_launcher.dart';

class MyPost extends StatefulWidget {
  @override
  _MyPostState createState() => _MyPostState();
}

class _MyPostState extends State<MyPost> {
  TabController _tabController;
  var users;

  CrudMedthods crudObj = new CrudMedthods();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  backgroundColor: Color.fromARGB(255, 30, 55, 91),
                  title: new Text('Posts'),
                  pinned: true,
                  floating: true,
                  forceElevated: innerBoxIsScrolled,
                  bottom: TabBar(
                    indicatorColor: Colors.white,
                    indicatorWeight: 4,
                    tabs: <Tab>[
                      Tab(text: "Donors"),
                      Tab(text: "Requests"),
                    ],
                    controller: _tabController,
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: <Widget>[
                Center(
                    child: RefreshIndicator(
                  onRefresh: () async {
                    return await Future.delayed(Duration(seconds: 1), () {
                      crudObj.getData().then((results) {
                        setState(() {
                          users = results;
                        });
                      });
                    });
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.white, Colors.white],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight),
                      ),
                      child: StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance
                              .collectionGroup('posts')
                              .where('role', isEqualTo: 'Contribute')
                              .orderBy('createdOn', descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            }
                            if (!snapshot.hasData) {
                              return Center(child: const Text('Loading...'));
                            }

                            return ListView(
                              children: [
                                Column(
                                  children: <Widget>[
                                    ListView.builder(
                                      primary: false,
                                      shrinkWrap: true,
                                      itemCount: snapshot.data.documents.length,
                                      padding: EdgeInsets.all(5.0),
                                      itemBuilder: (context, i) {
                                        DateTime myDateTime = (snapshot.data
                                                .documents[i].data['createdOn'])
                                            .toDate();

                                        return Container(
                                          child: Card(
                                            shadowColor: Colors.grey,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25.0),
                                            ),
                                            color: Colors.white,
                                            elevation: 10,
                                            child: Column(
                                              children: <Widget>[
                                                ListTile(
                                                  leading: Container(
                                                    width: 45,height: 45,
                                                    child: CircleAvatar(
                                                      
                                                      radius: 30.0,
                                                      backgroundImage: AssetImage(
                                                          'assets/images/wb.png'),
                                                      backgroundColor:
                                                          Colors.transparent,
                                                    ),
                                                  ),
                                                  title: Text(
                                                          '\n${snapshot.data.documents[i].data['name']}',
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
                                                    style:
                                                        TextStyle(fontSize: 9),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          30, 8, 30, 8),
                                                  child: Container(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                        '${snapshot.data.documents[i].data['item']} for ${snapshot.data.documents[i].data['foodCount']}',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        )),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          30, 8, 30, 8),
                                                  child: Container(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                      '${snapshot.data.documents[i].data['Address']}',
                                                    ),
                                                  ),
                                                ),
                                                ButtonBar(
                                                  alignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    IconButton(
                                                      onPressed: () {
                                                        launch(
                                                            ('tel:// ${snapshot.data.documents[i].data['Phone']}'));
                                                      },
                                                      icon: Icon(
                                                        Icons.phone,
                                                        color: Color.fromARGB(255, 30, 55, 91),
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (BuildContext context) => IndividualMap(
                                                                    lat: snapshot
                                                                        .data
                                                                        .documents[
                                                                            i]
                                                                        .data[
                                                                            'location']
                                                                        .latitude,
                                                                    lng: snapshot
                                                                        .data
                                                                        .documents[
                                                                            i]
                                                                        .data[
                                                                            'location']
                                                                        .longitude)));
                                                      },
                                                      icon: Icon(
                                                          Icons.location_on,
                                                          color:  Color.fromARGB(255, 30, 55, 91)),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            );
                          })),
                )),
                Center(
                    child: RefreshIndicator(
                  onRefresh: () async {
                    return await Future.delayed(Duration(seconds: 1), () {
                      crudObj.getData().then((results) {
                        setState(() {
                          users = results;
                        });
                      });
                    });
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.white, Colors.white],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight),
                      ),
                      child: StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance
                              .collectionGroup('posts')
                              .where('role', isEqualTo: 'Request')
                              .orderBy('createdOn', descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            }
                            if (!snapshot.hasData) {
                              return Center(child: const Text('Loading...'));
                            }

                            return ListView(
                              children: [
                                Column(
                                  children: <Widget>[
                                    ListView.builder(
                                      primary: false,
                                      shrinkWrap: true,
                                      itemCount: snapshot.data.documents.length,
                                      padding: EdgeInsets.all(5.0),
                                      itemBuilder: (context, i) {
                                        DateTime myDateTime = (snapshot.data
                                                .documents[i].data['createdOn'])
                                            .toDate();

                                        return Container(
                                          child: Card(
                                            shadowColor: Colors.grey,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25.0),
                                            ),
                                            color: Colors.white,
                                            elevation: 10,
                                            child: Column(
                                              children: <Widget>[
                                                ListTile(
                                                  leading: Container(
                                                    width: 45,
                                                    height: 45,
                                                    child: CircleAvatar(
                                                      radius: 30.0,
                                                      backgroundImage: AssetImage(
                                                          'assets/images/bb.png'),
                                                      backgroundColor:
                                                          Colors.transparent,
                                                    ),
                                                  ),
                                                  title: Text(
                                                          '\n${snapshot.data.documents[i].data['name']}',
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
                                                    style:
                                                        TextStyle(fontSize: 9),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          30, 8, 30, 8),
                                                  child: Container(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                        '${snapshot.data.documents[i].data['item']} for ${snapshot.data.documents[i].data['foodCount']}',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        )),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          30, 8, 30, 8),
                                                  child: Container(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                      '${snapshot.data.documents[i].data['Address']}',
                                                    ),
                                                  ),
                                                ),
                                                ButtonBar(
                                                  alignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    IconButton(
                                                      onPressed: () {
                                                        launch(
                                                            ('tel:// ${snapshot.data.documents[i].data['Phone']}'));
                                                      },
                                                      icon: Icon(
                                                        Icons.phone,
                                                        color:  Color.fromARGB(255, 30, 55, 91),
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (BuildContext context) => IndividualMap(
                                                                    lat: snapshot
                                                                        .data
                                                                        .documents[
                                                                            i]
                                                                        .data[
                                                                            'location']
                                                                        .latitude,
                                                                    lng: snapshot
                                                                        .data
                                                                        .documents[
                                                                            i]
                                                                        .data[
                                                                            'location']
                                                                        .longitude)));
                                                      },
                                                      icon: Icon(
                                                          Icons.location_on,
                                                          color:  Color.fromARGB(255, 30, 55, 91)),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            );
                          })),
                )),
              ],
              controller: _tabController,
            ),
          ),
        ),
      ),
    );
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
