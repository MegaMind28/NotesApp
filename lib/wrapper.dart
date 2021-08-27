import 'package:notes/screens/HomeScreen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:notes/model/user.dart';
import 'package:notes/screens/authentication.dart';

class NewWrapper extends StatefulWidget {
  @override
  _NewWrapperState createState() => _NewWrapperState();
}

class _NewWrapperState extends State<NewWrapper> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);


    if (user == null) {
      return Authentication();
    } else {
      return HomeScreen();
    }
  }
}
