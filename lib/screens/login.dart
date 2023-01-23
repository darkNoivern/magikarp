import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftoast/ftoast.dart';
import 'package:magikarp/services/auth.dart';
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

  final Stream<QuerySnapshot> _usersRefStream =
      FirebaseFirestore.instance.collection('users').snapshots();

  void login() {
    setState(() {
      _loading = true;
    });
    _auth
        .signInWithEmailAndPassword(
            email: _emailController.text.toString(),
            password: _passwordController.text.toString())
        .then((value) => {
              // db.collection("cities").doc("new-city-id").set({"name": "Chicago"});
            })
        .onError((error, stackTrace) => {
              // debugPrint(error);
            });

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference usersRef =
        FirebaseFirestore.instance.collection('users');

    // Future<void> addUser(result) {
    //   debugPrint(result);
    //   FToast.toast(
    //     context,
    //     duration: 2000,
    //     msg: "I'm FToast: ${result.toString()}",
    //     msgStyle: TextStyle(color: Colors.white),
    //   );
    //
    //   return
    //       .then((value) => FToast.toast(
    //             context,
    //             duration: 2000,
    //             msg: "I'm FToast: ${result.toString()}",
    //             msgStyle: TextStyle(color: Colors.white),
    //           ))
    //       .catchError((error) => FToast.toast(
    //             context,
    //             duration: 2000,
    //             msg: "I'm Eoast: ${result.toString()}",
    //             msgStyle: TextStyle(color: Colors.white),
    //           ));
    // }

    void signup() async {
      setState(() {
        _loading = true;
      });

      try {
        final UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.toString(),
          password: _passwordController.text.toString(),
        );

        await usersRef.doc(user.user?.uid).set({
          'username': _usernameController.text.toString(),
          'uid': user.user?.uid,
          'tasksCompleted': 0,
          'tasks': [],
        });

        print("Successfully created new user: ${user.toString()}");

      } catch (error) {
        print("Error creating new user: ${error.toString()}");
      }

      // _auth
      //     .createUserWithEmailAndPassword(
      //     email: _emailController.text.toString(),
      //     password: _passwordController.text.toString())
      //     .then((value) => addUser(value))
      //     .onError((error, stackTrace) => {
      // });
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
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 108.0),
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
                    if (_login == false)
                      SizedBox(
                        height: 16.0,
                      ),
                    if (_login == false)
                      TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            hintText: 'hellFrost',
                            hintStyle: TextStyle(
                                color: Colors.grey, fontFamily: 'Ubuntu_300'),
                            labelText: 'Username',
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
                              Icons.supervised_user_circle,
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
                                  child: Text(
                                _loading ? 'Loading' : 'Sign-Up',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Ubuntu_400'),
                              )),
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
                                  child: Text(
                                _loading ? 'Loading' : 'Login',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Ubuntu_400'),
                              )),
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
