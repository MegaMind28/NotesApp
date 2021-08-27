import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:notes/model/user.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';



import '../constants.dart';

class DetailScreen extends StatefulWidget {
  final Map data;
  final String time;
  final DocumentReference ref;
  

  DetailScreen(this.data, this.time, this.ref);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {

  @override


  String title;
  String description;
  bool isStarred;
 // bool isEdited=false;
  String UserUID;

  var _TitleController = TextEditingController();
  var _DescriptionController = TextEditingController();

  void delete() async {
    await widget.ref.delete().whenComplete(() =>


              Fluttertoast.showToast(
                  msg: "Note Deleted!",
                  toastLength: Toast.LENGTH_SHORT,
                  timeInSecForIosWeb: 2)

    ).onError((error, stackTrace) =>

        Fluttertoast.showToast(
            msg: "Something went wrong!",
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 2)

    );
    Navigator.pop(context);
  }


  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData(){
    title = widget.data['title'];
    description = widget.data['description'];
    isStarred = widget.data['Starred'];
    _TitleController = TextEditingController(text: "${title}");
    _DescriptionController = TextEditingController(text: "${description}");
  }


  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Save Note Changes?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Do you want to save change?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Save!'),
              onPressed: () {
                UpdateData();
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.indigo
              )
            ),
            TextButton(
                child: const Text('Exit!'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                    primary: Colors.grey,
                )
            ),
          ],
        );
      },
    );
  }

  void UpdateStar()async{
    CollectionReference ref = Firestore.instance
        .collection('users')
        .document(UserUID)
        .collection('notes');

    var data = {
      'Starred' : isStarred,
      'created': DateTime.now(),
    };

    await ref.document(widget.ref.documentID).updateData(data).whenComplete(() =>

    isStarred ?

    Fluttertoast.showToast(
        msg:  "Starred",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 2) : Fluttertoast.showToast(
        msg:  "Unstarred",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 2)



    ).onError((error, stackTrace) =>

        Fluttertoast.showToast(
            msg: "Something went wrong",
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 2)
    );
  }

   void UpdateData()async{
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

     await ref.document(widget.ref.documentID).updateData(data).whenComplete(() =>

         Fluttertoast.showToast(
             msg: "Note Updated!",
             toastLength: Toast.LENGTH_SHORT,
             timeInSecForIosWeb: 2)

     ).onError((error, stackTrace) =>

         Fluttertoast.showToast(
             msg: "Something went wrong",
             toastLength: Toast.LENGTH_SHORT,
             timeInSecForIosWeb: 2)
     );
     Navigator.pop(context);
   }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    UserUID = user.uid;
    return WillPopScope(
      onWillPop: () {
        if (title == widget.data['title'] && description == widget.data['description']) {
        Navigator.pop(context);
        } else
          return _showMyDialog();
      },
      child: GestureDetector(
        onTap: ()=> FocusScope.of(context).unfocus(),
        child: MaterialApp(
            home: Scaffold(
              resizeToAvoidBottomInset: false,
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
                               EdgeInsets.only(left: 20.0, right: 20.0, top: 14.0),
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                Column(
                                  children: [
                                    TextFormField(
                                      textCapitalization: TextCapitalization.sentences,
                                      decoration: InputDecoration.collapsed(
                                        hintText: "Title",
                                      ),
                                      controller: _TitleController,
                                      onChanged: (_val) {
                                        title = _val;
                                      },
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
                                      padding: EdgeInsets.only(top: 12.0),
                                      child:
                                      TextFormField(
                                        textCapitalization: TextCapitalization.sentences,
                                        controller: _DescriptionController,
                                        decoration: InputDecoration.collapsed(
                                      hintText: "Description",
                                        ),
                                        style: TextStyle(
                                      fontSize: 16.0,
                                      letterSpacing: 0.2,
                                      wordSpacing: 2.0,
                                      fontWeight: FontWeight.w100,
                                      fontFamily: 'Roboto',
                                      color: DarkPurple,
                                        ),
                                        onChanged: (_val) {
                                          description = _val;
                                        },
                                        maxLines: 20,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          widget.time,
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w100,
                                            fontStyle: FontStyle.italic
                                          ),
                                        ),
                                        Row(
                                          children: [

                                            IconButton(
                                                onPressed: () {
                                                  Fluttertoast.showToast(
                                                      msg: "Tapped Image Icon",
                                                      toastLength: Toast.LENGTH_SHORT,
                                                      timeInSecForIosWeb: 2);
                                                }, icon: Icon(Icons.image_outlined), color: Colors.grey),

                                            IconButton(
                                                onPressed: () {
                                                  Fluttertoast.showToast(
                                                      msg: "Tapped mic Icon",
                                                      toastLength: Toast.LENGTH_SHORT,
                                                      timeInSecForIosWeb: 2);
                                                }, icon: Icon(Icons.mic), color: Colors.grey),


                                          ],
                                        ),
                                      ],
                                    )
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
                            if(title == widget.data['title'] && description == widget.data['description']) {
                              Fluttertoast.showToast(
                                  msg: "No changes found!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  timeInSecForIosWeb: 2);
                          } else
                              {
                                if(title.isNotEmpty && description.isNotEmpty ){
                                  UpdateData();
                                }
                                else
                                Fluttertoast.showToast(
                                    msg: "Please type both details!",
                                    toastLength: Toast.LENGTH_SHORT,
                                    timeInSecForIosWeb: 2);
                                Navigator.pop(context);
                              }
                        },
                        icon: Icon(Icons.done),
                        iconSize: 30.0,
                      ),
                      label: 'Save',
                    ),


                    BottomNavigationBarItem(icon: IconButton(iconSize: 30.0,
                      icon: !isStarred ? Icon(
                          Icons.star_border,color: DarkPurple,) : Icon(
                          Icons.star,color: DarkPurple,),
                      onPressed: (){
                      setState(() {
                        isStarred = !isStarred;
                      });
                      UpdateStar();
                      },
                    ),label: 'Star'),

                    BottomNavigationBarItem(
                        icon: IconButton(
                          onPressed: () {
                            Share.share("Title:- $title , \n Description:- $description ");
                          }, icon: Icon(Icons.share_outlined), color: DarkPurple,iconSize: 30.0,),label: 'Delete'
                    ),

                    BottomNavigationBarItem(
                      icon: IconButton(
                          onPressed: () {
                            delete();
                          }, icon: Icon(Icons.delete), color: DarkPurple,iconSize: 30.0,),label: 'Delete'
                    )
                  ],
                ),
              ),
            ),
          ),
      ),
    );
  }
}
