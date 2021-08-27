import 'package:flutter/material.dart';
import 'package:notes/services/auth.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants.dart';

class Authentication extends StatefulWidget {
  @override
  _Authentication createState() => _Authentication();
}

class _Authentication extends State<Authentication> {
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
          home: Scaffold(
        body: SafeArea(
          child: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'NoteApp',
                    style: HeadingStyle,
                  ),
                  SvgPicture.asset(
                    'assets/splash.svg',
                    height: 400.0,
                    width: 100.0,
                  ),
                  Container(
                    constraints: BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
                    margin: EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: () {
                        AuthService.handleSignIn();
                      },
                     // color: Theme.of(context).accentColor,
                      child: Container(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Login With Google!',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ));
  }
}
