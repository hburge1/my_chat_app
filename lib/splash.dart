import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/home.dart';
import 'package:my_chat_app/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _navigatetohome();
  }
  _navigatetohome()async{
    await Future.delayed(const Duration(milliseconds: 1500),(){} );

    if(_auth.currentUser !=null){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>  Chat_Home_Page(user:_auth.currentUser!)));
    }
    else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const LoginScreen()));
    }
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Welcome",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26),)),
    );
  }
}
