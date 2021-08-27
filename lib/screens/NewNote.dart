import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notes/constants.dart';
import 'package:notes/model/user.dart';
import 'package:provider/provider.dart';

class CreateNewNote extends StatefulWidget {
  const CreateNewNote({Key key}) : super(key: key);

  @override
  CreateNewNoteState createState() => CreateNewNoteState();
}

class CreateNewNoteState extends State<CreateNewNote> {
  String title;
  String description;
  bool isStarred = false;
  String UserUID;

  final _TitleController = TextEditingController();
  final _DescriptionController = TextEditingController();

  void AddData()async{

    CollectionReference ref = Firestore.instance
        .collection('users')
        .document(UserUID)
        .collection('notes');

    var data = {
      'title': title,
      'description': description,
      'Starred' : isStarred,
      'created': DateTime.now(),
    };

    ref.add(data).whenComplete(() =>
        Fluttertoast.showToast(
            msg: "Note Added",
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 2)
    );
    Navigator.pop(context);

  }


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    UserUID = user.uid;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: EdgeInsets.only(left: 20.0),
                          child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.arrow_back_ios),
                              color: DarkPurple),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(10), // radius of 10
                              color: LightPurple // green as background color
                              )),
                    ],
                  ),
                ),
                color: Colors.white,
              ),
            ),
            Expanded(
              flex: 7,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    topLeft: Radius.circular(20.0),
                  ),
                  color: MedPurple,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20.0, top: 14.0),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration.collapsed(
                                hintText: "Title",
                              ),
                             controller: _TitleController,
                             textCapitalization: TextCapitalization.sentences,
                              style: TextStyle(
                                  fontSize: 28.0,
                                  color: DarkPurple,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                            Padding(
                              padding:  EdgeInsets.only(top: 8.0,bottom: 8.0),
                              child: SizedBox(
                                height: 1.0,
                                child: Container(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: TextFormField(
                                controller: _DescriptionController,
                                decoration: InputDecoration.collapsed(
                                  hintText: "Note Description",
                                ),
                                style: TextStyle(
                                  fontSize: 16.0,
                                  letterSpacing: 0.2,
                                  wordSpacing: 2.0,
                                  fontWeight: FontWeight.w100,
                                  fontFamily: 'Roboto',
                                  color: DarkPurple,
                                ),
                                maxLines: 20,
                                textCapitalization: TextCapitalization.sentences,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(boxShadow: <BoxShadow>[
          BoxShadow(color: PurpleShadow, blurRadius: 10)
        ]),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: MedPurple,
          fixedColor: DarkPurple,
          unselectedItemColor: DarkPurple,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: IconButton(
                onPressed: () async {

                    title = _TitleController.text;
                    description = _DescriptionController.text;

                  if(title.isNotEmpty && description.isNotEmpty){
                    AddData();
                  } else {

                    Fluttertoast.showToast(
                        msg: "Please type both details!",
                        toastLength: Toast.LENGTH_SHORT,
                        timeInSecForIosWeb: 2);
                  }
                },
                icon: Icon(Icons.done),
                iconSize: 30.0,
              ),
              label: 'Save',
            ),
            BottomNavigationBarItem(icon: IconButton(
              icon: isStarred?
              Icon(Icons.star,color: DarkPurple,):
              Icon(Icons.star_border,color: DarkPurple,),
              color: Colors.deepOrange,
              iconSize: 30.0,
              onPressed: (){
              setState(() {
                isStarred = !isStarred;
              });
              },
            ),label: 'Star'),
          ],
        ),
      ),
    );
  }
}
