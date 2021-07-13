import 'package:betterplace/screens/authenticate/mapt.dart';
import 'package:betterplace/screens/home/navigation_view/mypost.dart';
import 'package:betterplace/screens/home/navigation_view/newpost.dart';
import 'package:betterplace/screens/home/navigation_view/profile.dart';
import 'package:flutter/material.dart';
import 'package:betterplace/screens/home/home.dart';
import 'newpost.dart';
import 'package:location_permissions/location_permissions.dart';

class NavigationView extends StatefulWidget {
  @override
  _NavigationViewState createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  String message = 'unknown';
  PermissionStatus permission = PermissionStatus.unknown;
  bool openedSettings = false;
  bool shownBottomSheet = false;

  

 

  int _selectedTabIndex = 0;

  List _pages = [
    HomePage(),
    MapToggle(),
    NewPost(),
    MyPost(),
    Profile(),
  ];

  _changeIndex(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _pages[_selectedTabIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        onTap: _changeIndex,
        type: BottomNavigationBarType.fixed,
        selectedIconTheme: IconThemeData(
          size: 30,
        ),
        selectedFontSize: 12,
        
        
        showUnselectedLabels: false,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Color.fromARGB(255, 30, 55, 91),
        backgroundColor: Colors.white,
        elevation: 30.0,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.explore), label: "Explore"),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle,), label: "Add Post"),
          BottomNavigationBarItem(
              icon: Icon(Icons.featured_play_list), label: "Posts"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: "Profile"),
        ],
      ),
    );
  }
}
