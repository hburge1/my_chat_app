import 'dart:async';
import 'package:flutter/painting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:my_chat_app/models/fire_message.dart';
import 'package:my_chat_app/models/fire_user.dart';

class ChattingPage extends StatefulWidget {
  final String contactId;
  final String myId;

  final FireUser fireUser;
  final FireUser? myFireUser;

  ChattingPage({required this.fireUser, required this.contactId, required this.myId, this.myFireUser});

  @override
  _ChattingPageState createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  TextEditingController _messageController = TextEditingController();
  bool attachFile = false;
  double attachFileWidth = 0;
  ScrollController _controller = new ScrollController();
  FocusNode myFocusNode = FocusNode();
  Stream<QuerySnapshot>? messages;
  bool isOnline = false;
  String currentText = "";
  bool isContactOnline = false;

 // Call call;
  CollectionReference? chatReference;

  bool isRecording = false;
  bool isTyping = false;
//  AnimationController _animationController;

//  TextEditingController messageEditingController = new TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  void initState() {

    /*call = Call(
      callerId: widget.myId.toString(),
      callerName: GlobalValues.user.name,
      callerPic: GlobalValues.user.image,
      hasDialled: true,
      isVideo: false,
      receiverId: widget.fireUser.id.toString(),
      receiverPic: widget.fireUser.image,
      receiverName: widget.fireUser.name
    );
    //print(GlobalValues.user.id);
*/
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    double px = 1 / pixelRatio;

    return MaterialApp(
        home: Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: HexColor("#151520"),
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: GestureDetector(
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
          ),
          title: Container(
            alignment: Alignment.centerLeft,
            child: Row(
              children: <Widget>[
                Container(
                  width: 40,
                  height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.black.withOpacity(0.2)
                    ),
                    child: Center(child: Icon(Icons.person))
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  widget.fireUser.name,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )
              ],
            ),
          ),
        /*  actions: <Widget>[
            GestureDetector(
              child: Image.asset(
                "assets/phone_call.png",
                height: 20.0,
                width: 20.0,
              ),
              onTap: (){
                CallUtils.dial(from: GlobalValues.user,to: widget.fireUser,isVideo: false,context: context);
              },
            ),
            SizedBox(
              width: 15,
            ),
            GestureDetector(
              child: Icon(
                Icons.video_call,
                size: 20.0,
              ),
              onTap: (){
                CallUtils.dial(from: GlobalValues.user,to: widget.fireUser,isVideo: true,context: context);
              },
            ),
            SizedBox(
              width: 15,
            ),
            Image.asset("assets/search.png", height: 20.0, width: 20.0),
            SizedBox(
              width: 8,
            ),
            SizedBox(
              width: 15,
            ),
          ],*/
        ),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        padding: EdgeInsets.only(top: 8.0),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/chat_background.png'),
                fit: BoxFit.cover)),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: GestureDetector(
                    child: FutureBuilder(
                        future: getChatRoom(widget.myId, widget.contactId),
                        builder: (BuildContext context3,
                            AsyncSnapshot<Query> querySnapshot) {
                          if (querySnapshot.data == null) {
                            return ListView(
                              controller: _controller,
                              children: [
                                Container(
                                  color: Colors.transparent,
                                ),
                              ],
                            );
                          } else {
                            return StreamBuilder<QuerySnapshot>(
                              stream: querySnapshot.data!.snapshots(),
                              builder: (context1, snapshot) {
                                if (snapshot.hasData) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) => _scroll());

                                  return ListView.builder(
                                      itemCount: snapshot.data!.docs.length,
                                      controller: _controller,
                                      reverse: true,
                                      shrinkWrap: true,
                                      itemBuilder: (context2, index) {
                                        FireMessage message =
                                            FireMessage.fromMap(snapshot
                                                .data!.docs[index]
                                                .data() as Map<String,dynamic>);

                                        bool isMe = message.sender !=
                                            widget.contactId.toString();
                                        String hours =
                                            DateTime.fromMillisecondsSinceEpoch(
                                                    int.parse(message.time!))
                                                .hour
                                                .toString();
                                        String min =
                                            DateTime.fromMillisecondsSinceEpoch(
                                                    int.parse(message.time!))
                                                .minute
                                                .toString();

                                        String timeText = (hours.length == 2
                                                ? hours
                                                : "0" + hours) +
                                            ':' +
                                            (min.length == 2 ? min : "0" + min);
                                        bool seen = true;

                                        return Row(
                                          mainAxisAlignment: isMe
                                              ? MainAxisAlignment.start
                                              : MainAxisAlignment.end,
                                          children: [
                                            /*  isMe
                                                    ? Row(
                                                        children: [
                                                          seen
                                                              ? Opacity(
                                                                  opacity: 0.4,
                                                                  child: Text(
                                                                    ' seen ',
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .caption
                                                                        .copyWith(
                                                                            color:
                                                                                Theme.of(context).scaffoldBackgroundColor),
                                                                  ),
                                                                )
                                                              : Container(),
                                                          Opacity(
                                                            opacity: 0.4,
                                                            child: Text(
                                                              timeText,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .caption
                                                                  .copyWith(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .scaffoldBackgroundColor),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : Container(),*/
                                            ChatBubble(
                                              isMe: isMe,
                                              message: message.text != null
                                                  ? message.text!
                                                  : '',
                                            ),
                                            /* !isMe
                                                    ? Row(
                                                        children: [
                                                          Opacity(
                                                            opacity: 0.4,
                                                            child: Text(
                                                              timeText,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .caption
                                                                  .copyWith(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .scaffoldBackgroundColor),
                                                            ),
                                                          ),
                                                          seen
                                                              ? Opacity(
                                                                  opacity: 0.4,
                                                                  child: Text(
                                                                    ' seen ',
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .caption
                                                                        .copyWith(
                                                                            color:
                                                                                Theme.of(context).scaffoldBackgroundColor),
                                                                  ),
                                                                )
                                                              : Container(),
                                                        ],
                                                      )
                                                    : Container()*/
                                          ],
                                        );
                                      });
                                } else {
                                  return Container(
                                    child: Center(
                                      child: Text(''),
                                    ),
                                  );
                                }
                              },
                            );
                          }
                        }),
                    onTap: () {
                      FocusScopeNode currentFocus = FocusScope.of(context);

                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                    },
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4),
                child: TextField(
                  controller: _messageController,
                  style: TextStyle(color: Colors.white),
                  onChanged: (text) {
                    setState(() {
                      currentText = text;
                    });
                  },
                  onSubmitted: (text) {},
                  decoration: InputDecoration(
                    counter: null ?? Offstage(),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide.none),
                    fillColor: Colors.black,
                    filled: true,

                    hintText: "Type Your Message...",
                    hintStyle: TextStyle(color: Colors.grey),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.send, color: Colors.white),
                      onPressed: () {
                        sendMessage(widget.contactId.toString(), currentText);
                        _messageController.clear();
                      },
                    ),
                  ),
                  autofocus: false,
                  focusNode: myFocusNode,
                  onTap: () {
                    _scroll();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  sendMessage(String uid, String text) {
    if (text != null && text != '') {
      print(text);
      String time = DateTime.now().millisecondsSinceEpoch.toString();

      FireMessage fireMessage = FireMessage(
          sender: uid,
          text: text,
          time: time);

      chatReference!.add(fireMessage.toMap(fireMessage));

      // DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch).hour;

      Future.delayed(Duration(milliseconds: 300), _scroll());
    }
  }

  Future<Query> addNewChat(String myId, String contactId) async {
    Map<String, dynamic> chatMap = {
      "participants": [myId.toString(), contactId.toString()],
      "id": "$myId $contactId",
      myId.toString(): widget.myFireUser!
          .toJson(),
      contactId.toString(): widget.fireUser.toJson()
    };

    DocumentReference documentReference =
        await FirebaseFirestore.instance.collection("chats").add(chatMap);
    setState(() {
      chatReference = documentReference.collection("messages");
    });

    return chatReference!.orderBy('time', descending: true);
  }

  Future<Query> getChatRoom(String myId, String contactId) async {
    print('CALLED');
    Query query;
    try {
      query =
          FirebaseFirestore.instance.collection("chats").where("id", whereIn: [
        "$myId $contactId",
        "$contactId $myId",
      ]).limit(1);
      print(myId.toString() + " " + contactId.toString());
      print(contactId.toString() + " " + myId.toString());
    } catch (e) {
      print(e.toString());
      return addNewChat(myId, contactId);
    }
    QuerySnapshot querySnapshot = await query.get();
    if (querySnapshot.docs.isEmpty) {
      print("newchatroom");
      return addNewChat(myId, contactId);
    } else {
      print("old");
      setState(() {
        chatReference = querySnapshot.docs[0].reference.collection("messages");
      });

      return chatReference!.orderBy('time', descending: true);
    }
  }

  _scroll() {
    /* double maxExtent = _controller.position.maxScrollExtent;
    double distanceDifference = maxExtent - _controller.offset;
    double durationDouble = distanceDifference / 100;
*/
/*    _controller.animateTo(0.0,//_controller.position.maxScrollExtent,
        duration: Duration(milliseconds: 100), curve: Curves.linear);*/
  }
}

class ChatBubble extends StatelessWidget {
  final bool? isMe;
  final String? profileImg;
  final String? message;
  final String? time = "10:00 PM";
  final int? messageType;

  const ChatBubble({
    this.isMe,
    this.profileImg,
    this.message,
    this.messageType,
  }) ;

  @override
  Widget build(BuildContext context) {
    if (!isMe!) {
      return Container(
        padding: const EdgeInsets.all(3.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                    color: HexColor("#0070BF"),
                    borderRadius: getMessageType(!isMe!)),
                child: Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Text(
                    message!,
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(3.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              width: 15,
            ),
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                    color: HexColor("#151520"),
                    borderRadius: getMessageType(!isMe!)),
                child: Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Text(
                    message!,
                    style: TextStyle(color: Colors.white54, fontSize: 17),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }
  }

  getMessageType(messageType) {
    if (messageType) {
      // start message
      return BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(5),
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20));
    }
    // for sender bubble
    else {
      return BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(5),
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20));
    }
  }
}


