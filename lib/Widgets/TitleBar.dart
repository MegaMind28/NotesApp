import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notes/services/auth.dart';
import '../constants.dart';


class TitleBar extends StatefulWidget {
  const TitleBar({Key key}) : super(key: key);

  @override
  _TitleBarState createState() => _TitleBarState();
}

class _TitleBarState extends State<TitleBar> {

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Do you want to Sign Out?'),
          actions: <Widget>[

            TextButton(
                child: const Text('Yes'),
                onPressed: () {
                  AuthService.signOut();
                },
                style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.indigo
                )
            ),
            TextButton(
                child: const Text('No!'),
                onPressed: () {
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  primary: Colors.grey,
                  // backgroundColor: Colors.indigo
                )
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              margin: EdgeInsets.only(left: 20.0),
              child: IconButton(
                  onPressed: () {
                    _showMyDialog();
                  }, icon: Icon(Icons.logout), color: DarkPurple),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), // radius of 10
                  color: LightPurple // green as background color
              )),
          Text(
            'MyNotes',
            style: HeadingStyle,
          ),
          Container(
              margin: EdgeInsets.only(right: 20.0),
              child: IconButton(
                  onPressed: () {
                    Fluttertoast.showToast(
                        msg: "Tapped Search Button",
                        toastLength: Toast.LENGTH_SHORT,
                        timeInSecForIosWeb: 2);
                  },
                  icon: Icon(Icons.search),
                  color: DarkPurple),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), // radius of 10
                  color: LightPurple // green as background color
              )),
        ],
      ),
    );
  }
}
