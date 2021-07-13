import 'package:betterplace/screens/authenticate/authenticate.dart';
import 'package:betterplace/screens/home/navigation_view/navigation_view.dart';
import 'package:betterplace/screens/wrapper.dart';
import 'package:betterplace/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:betterplace/models/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
     SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(home: Wrapper(), routes: <String, WidgetBuilder>{
        '/navigate' : (BuildContext context) => NavigationView(),
         '/reg' : (BuildContext context) => Authenticate()
      }),
    );
  }
}
