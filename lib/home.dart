import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:my_chat_app/client_home.dart';
import 'package:my_chat_app/main.dart';
import 'package:my_chat_app/models/fire_user.dart';
import 'package:my_chat_app/models/globlas.dart';

import 'chatting_page.dart';
import 'models/fire_message.dart';

class Chat_Home_Page extends StatefulWidget {
  final User user;

  Chat_Home_Page({required this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class ChatInfo {
  String image;
  String name;
  String message;
  String time;
  int unread;
  bool online;

  ChatInfo(
      this.image, this.name, this.message, this.time, this.unread, this.online);
}

class _HomePageState extends State<Chat_Home_Page> {
  TextEditingController _searchController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
           // Navigator.pop(context);
          },
          child: Container(
              //  color: Colors.white,
              child: Icon(
            Icons.message,
            size: 20.0,
          )),
        ),
        actions: [
          Center(
            child: GestureDetector(
                onTap: (){
                  FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>MyApp()), (r) => false);

                },
                child: Container(child: Text("Logout  "),)),
          )
        ],
        title: Padding(
            padding: EdgeInsets.only(top: 5.0),
            child: Text("Chat List", textAlign: TextAlign.center)),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: getBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ClientHome(user: widget.user,)));
        },
        child: Icon(Icons.message,color: Colors.white,),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Stream<QuerySnapshot> getChats(String userId) {
    Query query = FirebaseFirestore.instance
        .collection("chats")
        .where('participants', arrayContains: userId);
    return query.snapshots();
  }

  Widget getBody() {
    return SafeArea(
        child: Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 15),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: getChats(widget.user.uid),
              builder: (context, snapshot) {
                return snapshot.hasData
                    ?
                snapshot.data!.size>0?
                ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        //           controller: _controller,
                        itemBuilder: (context, index) {
                          List<dynamic> participants =
                              snapshot.data!.docs[index].get('participants');
                          FireUser user = FireUser.fromJson(
                              snapshot.data!.docs[index].get(participants
                                  .where((element) =>
                                      element.toString() != widget.user.uid)
                                  .first));
                          return StreamBuilder<QuerySnapshot>(
                              stream: snapshot.data!.docs[index].reference
                                  .collection("messages")
                                  .orderBy('time', descending: true)
                                  .limit(1)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  FireMessage? fireMessage;
                                  if (snapshot.data!.docs.isNotEmpty) {
                                    fireMessage = FireMessage.fromMap(
                                        snapshot.data!.docs[0].data()!
                                            as Map<String, dynamic>);
                                  } else {
                                    fireMessage = null;
                                  }

                                  return InkWell(
                                    onTap: () {

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ChattingPage(myId: widget.user.uid,contactId: user.id,fireUser: user),
                                          ));
                                    },
                                    child: Container(
                                      height: 65,
                                      margin: EdgeInsets.symmetric(vertical: 5),
                                      padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.05),
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                        backgroundBlendMode: BlendMode.darken,
                                        /*    image: DecorationImage(
                                          image: NetworkImage(
                                              "http://coach.stackbuffers.com/public/uploads/images/" +
                                                  listOfUsers[index].image),
                                          fit: BoxFit.cover)*/
                                      ),
                                      child: Row(
                                        children: <Widget>[
                                            Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(25),
                                                  color: Colors.black.withOpacity(0.2)
                                              ),
                                              child: Center(child: Icon(Icons.person))),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Row(crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      user.name,
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black),
                                                    ),
                                                    Spacer(),
                                                    fireMessage!=null ?Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Text(
                                                        fireMessage!.time !=
                                                                null
                                                            ? getTimeFormat(DateTime
                                                                        .now()
                                                                    .millisecondsSinceEpoch -
                                                                int.parse(
                                                                    fireMessage
                                                                        .time!))
                                                            : "",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ):Container(),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                fireMessage!=null ? Row(
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              1.7,
                                                      child: Text(
                                                        fireMessage.text! !=
                                                                null
                                                            ? fireMessage.text!
                                                            : "",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    /*userMessages[index]
                                                            ['online']*/
                                                    false
                                                        ? Expanded(
                                                            child: Container(
                                                              width: 12.0,
                                                              height: 12.0,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    Colors.blue,
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                            ),
                                                          )
                                                        : Container(),
                                                  ],
                                                ):Container(),
                                                // Spacer(),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }
                                {
                                  return Container();
                                }
                              });
                        }):Container(
                  child: Center(
                    child: Text("No Chat Found",style: TextStyle(color: Colors.grey),),
                  ),
                )
                    : Container(
                        child: Center(
                          child: Text("No Chat Found",style: TextStyle(color: Colors.grey),),
                        ),
                      );
              },
            ),
          ),
          /*Column(
            children: List.generate(userMessages.length, (index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ChattingPage(
                                myId: GlobalValues.user.id,
                                contactId: 10,
                              )));
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 75,
                        height: 75,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: AssetImage(
                                          userMessages[index]['img']),
                                      fit: BoxFit.cover)),
                            ),
                            userMessages[index]['online']
                                ? Positioned(
                                    top: 52,
                                    left: 58,
                                    child: Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF66BB6A),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: [
                                Text(
                                  userMessages[index]['name'],
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                                Spacer(),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    userMessages[index]['created_at'],
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 1.7,
                                  child: Text(
                                    userMessages[index]['message'],
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white70,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                userMessages[index]['online']
                                    ? Expanded(
                                        child: Container(
                                          width: 12.0,
                                          height: 12.0,
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                            // Spacer(),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
          )*/
        ],
      ),
    ));
  }
}
