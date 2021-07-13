import 'package:betterplace/screens/home/navigation_view/addpost.dart';
import 'package:betterplace/screens/home/navigation_view/map2.dart';
import 'package:flutter/material.dart';


class MapToggle extends StatefulWidget {
  @override
  _MapToggleState createState() => _MapToggleState();
}

class _MapToggleState extends State<MapToggle> {

  bool showMap = true;
  void toggleView(){
    //print(showSignIn.toString());
    setState(() => showMap = !showMap);
  }

  @override
  Widget build(BuildContext context) {
    if (showMap) {
      // ignore: missing_required_param
      return MapOne(toggleView:  toggleView, );
    } else {
      // ignore: missing_required_param
      return MapTwo(toggleView:  toggleView,);
    }
  }
}