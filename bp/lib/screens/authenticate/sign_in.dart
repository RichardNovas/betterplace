import 'dart:async';

import 'package:betterplace/models/FadePageRoute.dart';
import 'package:betterplace/screens/authenticate/forgotpassword.dart';
import 'package:betterplace/screens/authenticate/register.dart';
import 'package:betterplace/screens/home/navigation_view/navigation_view.dart';
import 'package:betterplace/services/auth.dart';
import 'package:betterplace/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  // text field state
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
              child: Container(
                color: Colors.white,
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
                                'Login',
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
                                hintText: "Email",
                                hintStyle: TextStyle(color: Colors.black54),
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
                            obscureText: true,
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
                            validator: (val) => val.length < 6
                                ? 'Enter a password 6+ chars long'
                                : null,
                            onChanged: (val) {
                              setState(() => password = val);
                            },
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child: FlatButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  FadePPageRoute(page: ForgotPassword()),
                                );
                              },
                              child: Text(
                                'Forgot password?',
                                style: TextStyle(color: Colors.black),
                              ),
                              color: Colors.transparent,
                            ),
                          ),
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
                                    const EdgeInsets.fromLTRB(50, 15, 50, 15),
                                child: const Text(
                                  'Login',
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  setState(() => loading = true);
                                  dynamic result = await _auth
                                      .signInWithEmailAndPassword(
                                          email, password)
                                      .then(
                                          (value) => countDownTime());

                                  if (result == null) {
                                    setState(() {
                                      loading = false;
                                      error = 'Invalid input';
                                    });
                                  }
                                }
                              }),
                          SizedBox(height: 30.0),
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
                                    const EdgeInsets.fromLTRB(70, 15, 70, 15),
                                child: const Text(
                                  'Create an account',
                                ),
                              ),
                              onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Register()),
                                  )),
                          Text(
                            error,
                            style: TextStyle(color: Colors.red, fontSize: 14.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  countDownTime() async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    return Timer(
      Duration(microseconds: 1),
      () async {
        if (currentUser != null) {
          Navigator.pushReplacement(
            context,
            FadePageRoute(page: NavigationView()),
          );
        } else {
          setState(() {
            loading = false;
            error = 'Incorrect email & password';
          });
        }
      },
    );
  }
}
