import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_chat_app/models/globlas.dart';
import 'package:my_chat_app/home.dart';
import 'package:my_chat_app/signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.backGroundColor,
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Login',
                style: TextStyle(
                    fontSize: 40.0,fontWeight: FontWeight.bold
                ),
              )
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200]),
                  child:  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextFormField(
                      cursorColor: Colors.black,
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter email';
                        }
                        return null;
                      },
                      autofocus: false,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Email",
                          hintStyle:
                          TextStyle(fontSize: 16, color:   GlobalColors.buttonBlack,)),
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200]),
                  child:  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextFormField(
                      cursorColor: Colors.black,
                      obscureText: obscure,
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        return null;
                      },
                      autofocus: false,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 16,
                      ),

                      decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                            onTap: (){
                              setState(() {
                                obscure=!obscure;
                              });
                            },
                            child: obscure?const Icon(Icons.visibility_off_sharp,color: Colors.black,):const Icon(Icons.visibility,color: Colors.black,)),
                          border: InputBorder.none,
                          hintText: "Password",
                          hintStyle:
                          TextStyle(fontSize: 16, color:   GlobalColors.buttonBlack,)),
                    ),
                  )),
            ),
            GestureDetector(
              onTap: ()  async {
                if (_formKey.currentState!.validate()) {
                  try {
                    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: _emailController.text,
                        password: _passwordController.text
                    );
                    if(credential.user==null){
                      Fluttertoast.showToast(
                          msg: "Error",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );

                    }else{
                      Fluttertoast.showToast(
                          msg: "Login Successfully",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Chat_Home_Page(user:credential.user!)));

                    }

                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      Fluttertoast.showToast(
                          msg: "No user found for that email.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                      print('No user found for that email.');
                    } else if (e.code == 'wrong-password') {
                      Fluttertoast.showToast(
                          msg: "Wrong password provided for that user.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                      print('Wrong password provided for that user.');
                    }else{

                      print(e.message);
                    }
                  }
                }else{
                  Fluttertoast.showToast(
                      msg: "Wrong password provided for that user.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                }

              },
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                      color: GlobalColors.buttonBlack),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text("LOGIN",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.white
                        )),
                  ),
                ),
              ),
            ),

            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> SignUpScreen() ));
              },
              child:  Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,color:GlobalColors.buttonBlack,
                        fontSize: 16,
                      ),
                    ),
                    const Text(
                      "Sign Up",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,color:Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
