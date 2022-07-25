import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_chat_app/models/globlas.dart';
import 'package:my_chat_app/splash.dart';

import 'signup.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(  options: FirebaseOptions(
    apiKey: "AIzaSyDdx0UT1nxE67o-WmIKVaYPFddvXulPGII",
    projectId: "mychatapp-35752",
    messagingSenderId: "14193648798",
    appId: "1:14193648798:web:ed8a53a868f785cdc1878f",
  ),);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'My Chat App',
        theme: ThemeData(
            primarySwatch: primaryBlack,
            textTheme: GoogleFonts.montserratTextTheme(Theme.of(context).textTheme,
            )
        ),
        home:  SplashScreen()
    );
  }
}
