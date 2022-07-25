import 'dart:math' as math;
import 'dart:ui';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_chat_app/chatting_page.dart';
import 'package:my_chat_app/main.dart';
import 'package:my_chat_app/models/fire_user.dart';

class ClientHome extends StatefulWidget {

  User user;
  ClientHome({required this.user});

  @override
  _ClientHomeState createState() => _ClientHomeState();
}

class _ClientHomeState extends State<ClientHome> {
  TextEditingController searchcontroller = new TextEditingController();
  List<FireUser> listOfUsers = [];
  List<FireUser> allUsers = [];
  List<String> suggestions = [];

  @override
  void initState() {
    // TODO: implement initState
    getAllUsers().then((value) => setState(() {
          listOfUsers = value;
          allUsers = value;
          print(value.first.name);
          suggestions = value.map((e) => e.name).toList();
        }));
  }

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            //  color: Colors.white,
              child: Icon(
                Icons.arrow_back_ios_sharp,
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
      body: SafeArea(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(12),
          child: Column(
            children: <Widget>[

              Container(
                margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                // padding: EdgeInsets.all(20.0),
                height: MediaQuery.of(context).size.width / 8,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    controller: searchcontroller,
                    style: const TextStyle(color: Colors.white, fontSize: 16.0),

                    textInputAction: TextInputAction.search,
                    onChanged: (item) {
                      if (item.isEmpty) {
                          listOfUsers = allUsers;
                          loading = false;
                          setState((){});
                      } else {
                        userSearchCoachesDetails(item)
                            .then((value) => setState(() {
                          listOfUsers = value;
                          loading = false;
                        }));
                      }
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.grey.shade600,
                      filled: true,

                      // focusedBorder: UnderlineInputBorder(
                      //   borderSide: BorderSide(
                      //       color: Colors.blue, width: 1.0),
                      // ),
                      hintText: "Search Users Here...",
                      hintStyle: TextStyle(color: Colors.white70),
                      /*suffixIcon: GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                              color: HexColor("#0070BF"),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))),
                          // color: HexColor("#0070BF"),
                          child: Icon(Icons.search,
                              size: 24.0, color: Colors.white),
                        ),
                        onTap: () {
                          setState(() {
                            loading = true;
                          });
                          String search = searchcontroller.text;
                          if (search.isEmpty) {
                            getAllUsers().then((value) => setState(() {
                                  listOfUsers = value;
                                  loading = false;
                                }));
                          } else {
                            userSearchCoachesDetails(search)
                                .then((value) => setState(() {
                                      listOfUsers = value;
                                      loading = false;
                                    }));
                          }
                        },
                      ),*/
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    SizedBox.expand(
                      child: listOfUsers.where((element) => element.id!=widget.user.uid).isEmpty?const Center(child: Text("No User Found"),):ListView.builder(
                        itemCount: listOfUsers.where((element) => element.id!=widget.user.uid).length,
                        itemBuilder: (context, index) {

                          FireUser fireUser = listOfUsers.where((element) => element.id!=widget.user.uid).elementAt(index);

                          return GestureDetector(
                            onTap: () {

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChattingPage(myId: widget.user.uid,contactId: fireUser.id,fireUser: fireUser,myFireUser:allUsers.where((element) => element.id==widget.user.uid).first),
                                ));
                            },
                            child: Container(
                              height: 65,
                                margin: EdgeInsets.symmetric(vertical: 5),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(width: 10,),
                                   Container(
                                       height: 50,
                                       width: 50,
                                       decoration: BoxDecoration(
                                         borderRadius: BorderRadius.circular(25),
                                         color: Colors.black.withOpacity(0.2)
                                       ),
                                       child: Center(child: Icon(Icons.person))),
                                    SizedBox(width: 10,),
                                    Text(
                                      "${listOfUsers.where((element) => element.id!=widget.user.uid).toList()[index].name}",
                                      style: TextStyle(color: Colors.black,fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                    Spacer(),
                                  ],
                                )),
                          );
                        },
                      ),
                    ),
                    Visibility(
                        visible: loading,
                        child: SizedBox.expand(
                          child: Container(
                            color: Colors.black26,
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                              child: const Center(
                                  child: CircularProgressIndicator(
                                backgroundColor: Colors.transparent,
                              )),
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<FireUser>> getAllUsers() async {
    return (await FirebaseFirestore.instance.collection('users').get())
        .docs
        .map((e) => FireUser.fromJson(e.data()))
        .toList();
  }

  Future<List<FireUser>> userSearchCoachesDetails(String search) async {
    return allUsers.where((element) => element.name.toLowerCase().contains(search.toLowerCase())).toList();
  }
}
