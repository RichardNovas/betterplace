import 'dart:async';

import 'package:betterplace/screens/authenticate/authenticate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:betterplace/models/FadePageRoute.dart';
import 'home/navigation_view/navigation_view.dart';

class Wrapper extends StatefulWidget {
  Wrapper({Key key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  var _visible = true;
  final int splashDuration = 2;

  AnimationController animationController;
  Animation<double> animation;

  bool isLoading = false;
  bool isLoggedIn = false;
 
  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    WidgetsBinding.instance.ensureVisualUpdate();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    

    animationController = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 2),
    );
    animation =
        new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() {
      if (mounted) {
        this.setState(() {});
      }
    });
    animationController.forward();
    if (mounted) {
      setState(() {
        _visible = !_visible;
      });
    }
    countDownTime();
  }

  @override
  dispose() {
    animationController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  countDownTime() async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    return Timer(
      Duration(seconds: 2),
      () async {
        if (currentUser != null) {
          Navigator.pushReplacement(
            context,
            FadePageRoute(page: NavigationView()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            FadePageRoute(page: Authenticate()),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Color.fromARGB(255, 30, 55, 91)),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            new Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Text(
                            'From',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          Text(
                            'feelpurposed.com',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ))
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/bb1.png',
                  width: 130,
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
