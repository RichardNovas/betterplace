import 'package:betterplace/screens/authenticate/sign_in.dart';
import 'package:betterplace/services/auth.dart';
import 'package:betterplace/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  // text field state
  String email = '';
  String password = '';

  String firstname;

  String secondname;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            body: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Colors.white,
                  Colors.white,
                ], begin: Alignment.bottomLeft, end: Alignment.topRight)),
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width,
                  minHeight: MediaQuery.of(context).size.height,
                ),
                padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                child: Form(
                  key: _formKey,
                  child: Stack(
                    children: [
                      Center(
                          child: Image.asset(
                        'assets/images/betterplace.png',
                        width: 180,
                      )),
                      Column(
                        children: <Widget>[
                          SizedBox(
                            height: 170,
                          ),
                          Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Sign up',
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              )),
                          SizedBox(height: 15.0),
                          TextFormField(
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 30, 55, 91),
                                      width: 2.0),
                                ),
                                prefixIcon:
                                    Icon(Icons.person, color: Colors.grey),
                                hintText: "First name",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)))),
                            validator: (val) =>
                                val.isEmpty ? 'Enter your First name' : null,
                            onChanged: (val) {
                              setState(() => firstname = val);
                            },
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 30, 55, 91),
                                      width: 2.0),
                                ),
                                prefixIcon:
                                    Icon(Icons.person, color: Colors.grey),
                                hintText: "Second name",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)))),
                            validator: (val) =>
                                val.isEmpty ? 'Enter your Second name' : null,
                            onChanged: (val) {
                              setState(() => secondname = val);
                            },
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 30, 55, 91),
                                      width: 2.0),
                                ),
                                prefixIcon:
                                    Icon(Icons.email, color: Colors.grey),
                                hintText: "Email",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)))),
                            validator: (val) =>
                                val.isEmpty ? 'Enter an email' : null,
                            onChanged: (val) {
                              setState(() => email = val);
                            },
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 30, 55, 91),
                                      width: 2.0),
                                ),
                                prefixIcon: Icon(Icons.lock_outline,
                                    color: Colors.grey),
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)))),
                            obscureText: true,
                            validator: (val) => val.length < 6
                                ? 'Enter a password 6+ chars long'
                                : null,
                            onChanged: (val) {
                              setState(() => password = val);
                            },
                          ),
                          SizedBox(height: 20.0),
                          RaisedButton(
                              textColor: Colors.white,
                              color: Colors.transparent,
                              padding: EdgeInsets.all(0),
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(20.0),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  gradient: LinearGradient(
                                    colors: <Color>[
                                      Color.fromARGB(255, 30, 55, 91),
                                      Colors.black,
                                    ],
                                  ),
                                ),
                                padding:
                                    const EdgeInsets.fromLTRB(60, 15, 60, 15),
                                child: const Text(
                                  'Sign up',
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  setState(() => loading = true);
                                  dynamic result = await _auth
                                      .registerWithEmailAndPassword(
                                          email, password)
                                      .whenComplete(() async {
                                    final FirebaseAuth _auth =
                                        FirebaseAuth.instance;
                                    FirebaseUser user =
                                        await _auth.currentUser();
                                    Firestore.instance
                                        .collection('users')
                                        .document(user.uid)
                                        .collection('Email Registration')
                                        .document()
                                        .setData({
                                      'firstname': this.firstname,
                                      'secondname': this.secondname,
                                      'email': this.email,
                                      'createdOn': FieldValue.serverTimestamp(),
                                    }).catchError((e) {
                                      print(e);
                                    });
                                  });
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              SignIn()));

                                  if (result == null) {
                                    setState(() {
                                      loading = false;
                                      error = 'Please supply a valid email';
                                    });
                                  }
                                }
                              }),
                          FlatButton(
                            textColor: Colors.black,
                            onPressed: () => Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => SignIn()),
                              (Route<dynamic> route) => false,
                            ),
                            child: Text('Already have account? Login'),
                          ),
                          Text(
                            error,
                            style: TextStyle(color: Colors.red, fontSize: 14.0),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
