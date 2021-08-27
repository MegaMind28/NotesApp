import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/Widgets/TitleBar.dart';
import 'package:notes/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes/model/user.dart';
import 'package:notes/screens/DetailScreen.dart';
import 'package:notes/screens/NewNote.dart';
import 'package:notes/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          TitleBar(),
          SizedBox(
            height: 30.0,
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection("users")
                    .document(user.uid)
                    .collection("notes")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.documents.length == 0) {
                      return Center(
                        heightFactor: MediaQuery.of(context).size.height,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              color: Colors.white,
                              child: SvgPicture.asset('assets/empty.svg',
                              height: 300.0,
                              width: 300.0,),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0,right: 10.0),
                              child: Text(
                                'Create new note to keep track of your routine!',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: DarkPurple,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.separated(
                      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      shrinkWrap: true,
                      itemCount: snapshot.data.documents.length,
                      separatorBuilder : (context,index) {
                       return SizedBox(
                          height: 1.0,
                          child: const DecoratedBox(
                            decoration: const BoxDecoration(
                                color: MedPurple),
                          ),
                        );
                      },
                      itemBuilder: (
                        context,
                        index,
                      ) {
                        Map NotesData = snapshot.data.documents[index].data;
                        bool isStar = NotesData['Starred'];
                        DateTime mydateTime = NotesData['created'].toDate();
                        String formattedTime =
                            DateFormat.yMMMd().add_jm().format(mydateTime);

                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Container(
                                child: InkWell(
                                  onTap: () {
                                    print(NotesData['Starred']);
                                    Navigator.of(context)
                                        .push(
                                      MaterialPageRoute(
                                        builder: (context) => DetailScreen(
                                          NotesData,
                                          formattedTime,
                                          snapshot
                                              .data.documents[index].reference,
                                        ),
                                      ),
                                    )
                                        .then((value) {
                                      setState(() {});
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 20,top: 12.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  child: Text(
                                                    "${NotesData['title']}",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontFamily: "Robto",
                                                      fontWeight: FontWeight.bold,
                                                      color: DarkPurple,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      right: 10),
                                                  child: Row(
                                                    children: [
                                                      !isStar
                                                          ? Icon(
                                                              Icons.star_border)
                                                          : Icon(
                                                                Icons.star,
                                                              color: Colors.amber,
                                                            ),
                                                      Icon(Icons.more_vert)
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.55,
                                                  alignment: Alignment.bottomLeft,
                                                  child: Text(
                                                    "${NotesData['description']}",
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontFamily: "Roboto",
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.grey.shade400,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      right: 20.0),
                                                  child: Container(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: Text(
                                                      formattedTime,
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        fontStyle: FontStyle.italic,
                                                        fontFamily: "Roboto",
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20.0,
                                            ),
                                          ],
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  } else
                    return Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                }),
          )
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateNewNote()),
          );
        },
        child: Icon(Icons.add),
        foregroundColor: Colors.white,
        backgroundColor: DarkPurple,
      ),
    );
  }
}
