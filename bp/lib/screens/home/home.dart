import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    checkLatestVersion();
  }

  int version = 1;
  void checkLatestVersion() {
//Here i am getting just the value of the latest version stored on firebase.
    var user =
        Firestore.instance.collection("versionControl").document('version');
    user.get().then((data) {
      // ignore: unrelated_type_equality_checks
      if (data.data.length > 2) {
        setState(() {
          print('update');
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                    title: Text('New Update Available'),
                    content: Text('Please update your current version'),
                    actions: <Widget>[
                      FlatButton(
                          onPressed: () {
                            _update();
                          },
                          child: Text('Update'))
                    ]);
              });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Container(
            alignment: Alignment.topLeft,
            child: Image.asset(
              'assets/images/betterplace.png',
              width: 120,
            )),
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Column(
            children: <Widget>[
              Stack(
                children: [
                  Column(
                    children: <Widget>[
                      SizedBox(height: 20),
                      Container(
                        alignment: Alignment.centerRight,
                        child: StreamBuilder(
                            stream: getUsersdocumentStreamSnapshots(context),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Text("");
                              }

                              return Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                                alignment: Alignment.centerRight,
                                color: Colors.transparent,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      'Welcome',
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 30, 55, 91),
                                          fontFamily: 'Montserrat',
                                          fontSize: 28.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '${snapshot.data.documents[0]['firstname']}',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Montserrat',
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              );
                            }),
                        height: 100,
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 320,
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  
                                ],
                              ),
                            ),
                            FlatButton(
                                onPressed: () {
                                  _launchURL();
                                },
                                child: Text('Read more')),
                            SizedBox(height: 20),
                          ],
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40)),
                            boxShadow: [
                              BoxShadow(blurRadius: 20.0, color: Colors.grey)
                            ]),
                        height: 520,
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      SizedBox(
                        height: 150,
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 26.0, vertical: 10.0),
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: PageView(
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              Card(
                                shadowColor: Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40.0),
                                ),
                                color: Color.fromARGB(255, 30, 55, 91),
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      title: Padding(
                                        padding: const EdgeInsets.only(top: 28),
                                        child: Text('\tWHY THIS',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            )),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          30, 15, 30, 5),
                                      child: Container(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                            '\tMaybe you may think this is useless but it is a basic need for someone else \n\tWe are here to provide your contribution to the right people who are in need',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 17)),
                                      ),
                                    ),
                                    SizedBox(height: 30,),
                                    ButtonBar(
                                    alignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                  Row(
                                                    children: [
                                                      Text('Swipe  ',style: TextStyle(color: Colors.white),),
                                                      Icon(Icons.arrow_forward_ios,color: Colors.white,)
                                                    ],
                                                  )
                                                  ],
                                                ),
                                  ],
                                ),
                              ),
                              Card(
                                shadowColor: Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40.0),
                                ),
                                color: Color.fromARGB(255, 30, 55, 91),
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      title: Padding(
                                        padding: const EdgeInsets.only(top: 28),
                                        child: Text('\tJOIN WITH US',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            )),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          30, 22, 30, 8),
                                      child: Container(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                            '\t\t Become a volunteer in your free time. Collect food/clothes from the providers and deliver to the homeless',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 18)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Card(
                                shadowColor: Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40.0),
                                ),
                                color: Color.fromARGB(255, 30, 55, 91),
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      title: Padding(
                                        padding: const EdgeInsets.only(top: 28),
                                        child: Text('\tGIVE',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            )),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          30, 18, 30, 0),
                                      child: Container(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                            '\t\tBetter Place to SHARE AND PROVIDE your FOOD and UNUSED CLOTHES\n\t\tWhat are you waiting for\nMake a post now!',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 18)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Card(
                                shadowColor: Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40.0),
                                ),
                                color: Color.fromARGB(255, 30, 55, 91),
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      title: Padding(
                                        padding: const EdgeInsets.only(top: 28),
                                        child: Text('\tREQUEST',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            )),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          30, 28, 30, 8),
                                      child: Container(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                            '\t\tBetter Place to REQUEST for the people who are in need',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 18)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ],
              ),
            ],
          )
        ],
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

  _launchURL() async {
    const url = 'https://www.feelpurposed.com/better-place';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _donate() async {
    const url = 'https://www.feelpurposed.com/better-place';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _update() async {
    const url = 'https://www.feelpurposed.com/better-place';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
