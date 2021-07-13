import 'package:flutter/material.dart';

class FadePageRoute extends PageRouteBuilder {
  final Widget page;
  FadePageRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
            
          ) =>
             SlideTransition(
    position: Tween(
            begin: Offset(0, 1.0),
            end: Offset(0.0, 0.0))
        .animate(animation),
        
    child: child,
));
        
}

class FadePPageRoute extends PageRouteBuilder {
  final Widget page;
  FadePPageRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
            
          ) =>
             SlideTransition(
    position: Tween(
            begin: Offset(1.0, 0),
            end: Offset(0.0, 0.0))
        .animate(animation),
        
    child: child,
));
        
}