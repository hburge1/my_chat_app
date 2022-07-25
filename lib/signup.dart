
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_chat_app/models/globlas.dart';
import 'package:my_chat_app/home.dart';
import 'login.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool obscure= true;



  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: GlobalColors.backGroundColor,
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Chat App',
                style: TextStyle(
                  fontSize: 40.0,fontWeight: FontWeight.bold
                ),
              )
            ),
             const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Create Your Account',
                style: TextStyle(
                  fontSize: 30.0,
                ),

              )
            ), Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200]),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextFormField(
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter name';
                        }
                        return null;
                      },
                      autofocus: false,
                      cursorColor: Colors.black,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      decoration:  InputDecoration(
                          border: InputBorder.none,
                          hintText: "Name",
                          hintStyle:
                          TextStyle(fontSize: 16, color: GlobalColors.buttonBlack)),
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Container(
                  decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200]),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter email';
                        }
                        return null;
                      },
                      autofocus: false,
                      cursorColor: Colors.black,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      decoration:  InputDecoration(
                          border: InputBorder.none,
                          hintText: "Email",
                          hintStyle:
                              TextStyle(fontSize: 16, color: GlobalColors.buttonBlack)),
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200]),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextFormField(
                      obscureText: obscure,
                      controller: passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Password';
                        }
                        return null;
                      },
                      autofocus: false,
                      cursorColor: Colors.black,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      decoration:   InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: (){
                            setState(() {
                              obscure=!obscure;
                            });
                          },

                            child: obscure?Icon(Icons.visibility_off_sharp,color:Colors.black,):
                           Icon(Icons.visibility,color:Colors.black,)),
                          border: InputBorder.none,
                          hintText: "Password",
                          hintStyle:
                          TextStyle(fontSize: 16,)),
                    ),
                  )),
            ),

            GestureDetector(
              onTap: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text,
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
                          msg: "Registration Success",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                     await  FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set({"id":credential.user!.uid,"name":nameController.text,'email':emailController.text});
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  Chat_Home_Page(user:credential.user!)));

                    }

                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      Fluttertoast.showToast(
                          msg: "The password provided is too weak.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                      print('The password provided is too weak.');
                    } else if (e.code == 'email-already-in-use') {
                      Fluttertoast.showToast(
                          msg: "The account already exists for that email.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                      print('The account already exists for that email.');
                    }
                  } catch (e) {
                    print(e);

                  }
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   const SnackBar(content: Text('User added')),
                  // );
                }


                // await users.add({
                //   'username': nameText,
                //   'password': passwordText,
                // }).then((value) => print("user added"));
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                      color:  GlobalColors.buttonBlack),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text("CREATE",
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
                Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginScreen() ));
              },
              child:  Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Already have an account?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,color:GlobalColors.buttonBlack,
                    fontSize: 16,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
