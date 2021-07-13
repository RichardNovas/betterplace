import 'package:betterplace/screens/authenticate/forgotpassword.dart';
import 'package:betterplace/screens/authenticate/sign_in.dart';
import 'package:betterplace/screens/home/navigation_view/individualMap.dart';
import 'package:betterplace/services/crud.dart';
import 'package:betterplace/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
 
  var users;
  bool loading = false;

  CrudMedthods crudObj = new CrudMedthods();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openEndDrawer() {
    _scaffoldKey.currentState.openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            key: _scaffoldKey,
            endDrawer: Container(
              width: 235,
              child: Drawer(
                // Add a ListView to the drawer. This ensures the user can scroll
                // through the options in the drawer if there isn't enough vertical
                // space to fit everything.
                child: ListView(
                  // Important: Remove any padding from the ListView.
                  padding: EdgeInsets.only(top: 20),
                  children: <Widget>[
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                          boxShadow: [
                            BoxShadow(blurRadius: 2.0, color: Colors.grey)
                          ]),
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 15,
                          ),
                          Icon(
                            Icons.settings,
                            color: Colors.black54,
                          ),
                          Text(
                            '  Settings',
                            style: TextStyle(fontSize: 17),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      trailing: Icon(Icons.security),
                      title: Text('Change Password'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ForgotPassword()));
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Log Out',
                        style: TextStyle(color: Colors.blue),
                      ),
                      onTap: () {
                       setState(() {
            loading = true;
            _signOut().then((value) => 
                         Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => SignIn())));
          });
                       
                      },
                    ),
                  ],
                ),
              ),
            ),
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Color.fromARGB(255, 30, 55, 91),
              actions: <Widget>[
                IconButton(
                  onPressed: _openEndDrawer,
                  icon: Icon(Icons.settings),
                  color: Colors.white,
                ),
              ],
            ),
            body: ListView(
              children: [
                Column(
                  children: <Widget>[
                    StreamBuilder(
                        stream: getUsersdocumentStreamSnapshots(context),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Text("\n\n\n\nLoading...\n\n\n\n");
                          }

                          return Stack(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 30, 55, 91),
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(70)),
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 20.0, color: Colors.grey)
                                    ]),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      child: CircleAvatar(
                                        radius: 40.0,
                                        backgroundImage: AssetImage(
                                            'assets/images/whitet.png'),
                                        backgroundColor: Colors.transparent,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      alignment: Alignment(0.0, -0.40),
                                      color: Colors.transparent,
                                      child: Text(
                                        '${snapshot.data.documents[0]['firstname']} ${snapshot.data.documents[0]['secondname']}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Montserrat',
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(width: 40.0),
                                    Container(
                                      height: 40.0,
                                      child: Center(
                                        child: Text(
                                            '${snapshot.data.documents[0]['email']}',
                                            style: TextStyle(
                                                fontFamily: 'Quicksand',
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white
                                                    .withOpacity(0.8))),
                                      ),
                                    ),
                                    SizedBox(height: 30)
                                  ],
                                ),
                              )
                            ],
                          );
                        }),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                        padding: EdgeInsets.only(
                          left: 5.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'My Post',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 30, 55, 91),
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0),
                            ),
                          ],
                        )),
                    SizedBox(height: 10.0),
                    _myPost(),
                    SizedBox(height: 10.0),
                  ],
                ),
              ],
            ),
          );
  }

  Widget _myPost() {
    return StreamBuilder<QuerySnapshot>(
        stream: getUsersPostsStreamSnapshots(context),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return Center(child: const Text('Empty'));
          }

          return ListView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, i) {
                DateTime myDateTime =
                    (snapshot.data.documents[i].data['createdOn']).toDate();
                return Container(
                  child: Card(
                    shadowColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    color: Colors.white,
                    elevation: 20,
                    child: Column(
                      children: <Widget>[
                        new ListTile(
                          leading: Container(
                            width: 45,
                            height: 45,
                            child: CircleAvatar(
                              radius: 30.0,
                              backgroundImage:
                                  AssetImage('assets/images/wb.png'),
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                          title:Text(
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
                            style: TextStyle(fontSize: 9),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 8, 30, 8),
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                                '${snapshot.data.documents[i].data['item']} for ${snapshot.data.documents[i].data['foodCount']}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 8, 30, 8),
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              '${snapshot.data.documents[i].data['Address']}',
                            ),
                          ),
                        ),
                        ButtonBar(
                          alignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {
                                launch(
                                    ('tel:// ${snapshot.data.documents[i].data['Phone']}')); // Perform some action
                              },
                              icon: Icon(Icons.phone,
                                  color: Color.fromARGB(255, 30, 55, 91)),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            IndividualMap(
                                                lat: snapshot.data.documents[i]
                                                    .data['location'].latitude,
                                                lng: snapshot
                                                    .data
                                                    .documents[i]
                                                    .data['location']
                                                    .longitude)));
                              },
                              icon: Icon(Icons.location_on,
                                  color: Color.fromARGB(255, 30, 55, 91)),
                            ),
                            IconButton(
                              onPressed: () async {
                                await Firestore.instance.runTransaction(
                                    (Transaction myTransaction) async {
                                  await myTransaction.delete(
                                      snapshot.data.documents[i].reference);
                                }).then((value) => print('object'));
                              },
                              icon: Icon(
                                Icons.delete,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              });
        });
  }

  Future _signOut() async {
    try {
      return await FirebaseAuth.instance.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Stream<QuerySnapshot> getUsersPostsStreamSnapshots(
      BuildContext context) async* {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser user = await _auth.currentUser();
    yield* Firestore.instance
        .collection("users")
        .document(user.uid)
        .collection("posts")
        .snapshots();
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

  void deleted() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser user = await _auth.currentUser();
    final CollectionReference vaultCollection = Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('posts');
    vaultCollection.document().delete().then((value) => print(vaultCollection));
  }
  
}
