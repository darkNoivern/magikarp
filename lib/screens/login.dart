import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftoast/ftoast.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _login = false;
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  bool _loading = false;
  bool _see = false;

  final Stream<QuerySnapshot> _usersRefStream =
      FirebaseFirestore.instance.collection('users').snapshots();

  void login() async {

    setState(() {
      _loading = true;
    });
    try {
      await _auth.signInWithEmailAndPassword(
          email: _emailController.text.toString(),
          password: _passwordController.text.toString()
      );

      final snackBar = await SnackBar(
        /// need to set following properties for best effect of awesome_snackbar_content
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Congratulations!',
          message: 'LoggedIn Successfully',
          /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
          contentType: ContentType.success,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);

    }
    catch(error){
        final snackBar = SnackBar(
        /// need to set following properties for best effect of awesome_snackbar_content
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Snap!',
          message: '$error',
          /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }


    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference usersRef = FirebaseFirestore.instance.collection('users');

    void signup() async {
      setState(() {
        _loading = true;
      });

      try {
        final UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.toString(),
          password: _passwordController.text.toString(),
        );

        final snackBar = await SnackBar(
          /// need to set following properties for best effect of awesome_snackbar_content
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Congratulations!',
            message: 'Registered Successfully',
            /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
            contentType: ContentType.success,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);

        await usersRef.doc(user.user?.uid).set({
          'username': _usernameController.text.toString(),
          'uid': user.user?.uid,
          'tasksCompleted': 0,
          'tasks': [],
        });

        print("Successfully created new user: ${user.toString()}");

      } catch (error) {

        _emailController.clear();
        _passwordController.clear();

        final snackBar = SnackBar(
          /// need to set following properties for best effect of awesome_snackbar_content
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Snap!',
            message: '$error',
            /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
            contentType: ContentType.failure,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);

        print("Error creating new user: ${error.toString()}");
      }

      setState(() {
        _loading = false;
      });
    }

    return StreamBuilder<QuerySnapshot>(
        stream: _usersRefStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Scaffold(
                body: SingleChildScrollView(
                    child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 128.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(
                          child: Text(
                        'Login Page',
                        style: TextStyle(fontFamily: 'Ubuntu_400'),
                      )),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            setState(() {
                              _login = false;
                            });
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                          },
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: (_login == false)
                                  ? Color(0xFF212529)
                                  : Colors.transparent,
                            ),
                            child: Center(
                                child: Text(
                              'Sign-up',
                              style: TextStyle(
                                  color: ((_login == false)
                                      ? Colors.white
                                      : Colors.black),
                                  fontFamily: 'Ubuntu_400'),
                            )),
                          ),
                        )),
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            setState(() {
                              _login = true;
                            });
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                          },
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: _login
                                  ? Color(0xFF212529)
                                  : Colors.transparent,
                            ),
                            child: Center(
                                child: Text(
                              'Login',
                              style: TextStyle(
                                  color: (_login ? Colors.white : Colors.black),
                                  fontFamily: 'Ubuntu_400'),
                            )),
                          ),
                        )),
                      ],
                    ),
                    SizedBox(
                      height: 32.0,
                    ),
                    TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'abc@gmail.com',
                          hintStyle: TextStyle(
                              color: Colors.grey, fontFamily: 'Ubuntu_300'),
                          labelText: 'Email',
                          labelStyle: TextStyle(fontFamily: 'Ubuntu_400'),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF212529)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF212529)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xFF212529), width: 2.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          prefixIcon: Icon(
                            Icons.alternate_email_rounded,
                            color: Color(0xFF212529),
                          ),
                        ),
                        textAlign: TextAlign.left,
                        keyboardType: TextInputType.text,

                        // keyboardAppearance: ,
                        style: TextStyle(
                          fontFamily: 'Ubuntu_300',
                          fontSize: 16.0,
                        ),
                        onSubmitted: (value) {
                          // getData();
                        }),
                    SizedBox(
                      height: 16.0,
                    ),
                    TextField(
                      obscureText: !_see,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          hintText: '************',
                          hintStyle: TextStyle(
                              color: Colors.grey, fontFamily: 'Ubuntu_300'),
                          labelText: 'Password',
                          labelStyle: TextStyle(fontFamily: 'Ubuntu_400'),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF212529)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF212529)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xFF212529), width: 2.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          prefixIcon: Icon(
                            Icons.lock_open_rounded,
                            color: Color(0xFF212529),
                          ),
                          suffixIcon: InkWell(
                            onTap: (){
                              setState(() {
                                bool currSee = _see;
                                _see = !currSee;
                              });
                            },
                            child: Icon(
                              _see ? Icons.close : Icons.remove_red_eye_rounded,
                              color: Color(0xFF212529),
                            ),
                          )
                        ),
                        textAlign: TextAlign.left,
                        keyboardType: TextInputType.text,

                        // keyboardAppearance: ,
                        style: TextStyle(
                          fontFamily: 'Ubuntu_300',
                          fontSize: 16.0,
                        ),
                        onSubmitted: (value) {
                          // getData();
                        }),
                    SizedBox(
                      height: 16.0,
                    ),
                    if (_login == false)
                      Row(
                        children: [
                          Expanded(
                              child: InkWell(
                            onTap: () {
                              signup();
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Color(0xFF212529),
                              ),
                              height: 56,
                              child: Center(
                                  child: _loading ? CircularProgressIndicator(color: Colors.white,) : Text('Sign-Up', style: TextStyle(color: Colors.white, fontFamily: 'Ubuntu_400'),)
          ),
                            ),
                          )),
                        ],
                      ),
                    if (_login)
                      Row(
                        children: [
                          Expanded(
                              child: InkWell(
                            onTap: () {
                              login();
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Color(0xFF212529),
                              ),
                              height: 56,
                              child: Center(
                                  child: _loading ? CircularProgressIndicator(color: Colors.white,) : Text('Login', style: TextStyle(color: Colors.white, fontFamily: 'Ubuntu_400'),)
                              ),
                            ),
                          )),
                        ],
                      ),
                  ]),
            ))),
          );
        });
  }
}
