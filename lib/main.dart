import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes/services/auth.dart';
import 'package:notes/wrapper.dart';
import 'package:provider/provider.dart';

import 'model/user.dart';

void main() {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, //top bar color
    statusBarIconBrightness: Brightness.dark, //top bar icons
    systemNavigationBarColor: Colors.white, //bottom bar color
    systemNavigationBarIconBrightness: Brightness.dark, //bottom bar icons
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        title: 'Notes App',
        debugShowCheckedModeBanner: false,
        home: NewWrapper(),
      ),
    );
  }
}
