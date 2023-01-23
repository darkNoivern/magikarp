import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftoast/ftoast.dart';

class TaskMaster extends StatefulWidget {
  const TaskMaster({Key? key}) : super(key: key);

  @override
  State<TaskMaster> createState() => _TaskMasterState();
}

class _TaskMasterState extends State<TaskMaster> {

  TextEditingController _taskController = new TextEditingController();

  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();

  Stream documentStream = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
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
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, top: 16.0, bottom: 32.0),
                  child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(
                            child: Text(
                              'Task Master',
                              style: TextStyle(fontFamily: 'Ubuntu_400'),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextField(
                                  controller: _taskController,
                                  decoration: InputDecoration(
                                    hintText: 'Add a task',
                                    hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: 'Ubuntu_300'),
                                    labelText: 'Task',
                                    labelStyle:
                                        TextStyle(fontFamily: 'Ubuntu_400'),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFF212529)),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFF212529)),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFF212529), width: 2.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.text_fields_sharp,
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
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Expanded(
                                child: InkWell(
                              onTap: () {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser?.uid
                                        .toString())
                                    .update({
                                  "tasks": FieldValue.arrayUnion([
                                    {
                                      'description':
                                          _taskController.text.toString(),
                                      'createdAt': Timestamp.now(),
                                    }
                                  ])
                                });

                                final snackBar = SnackBar(
                                  /// need to set following properties for best effect of awesome_snackbar_content
                                  elevation: 0,
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.transparent,
                                  content: AwesomeSnackbarContent(
                                    title: 'Hi User!',
                                    message: 'Task added successfully',
                                    /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                    contentType: ContentType.help,
                                  ),
                                );

                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(snackBar);

                                _taskController.clear();

                                FocusScopeNode currentFocus =
                                    FocusScope.of(context);
                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                              },
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: Color(0xFF212529),
                                ),
                                child: Center(
                                    child: Text(
                                  'Add',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Ubuntu_500',
                                  ),
                                )),
                              ),
                            ))
                          ],
                        ),
                        SizedBox(
                          height: 32,
                        ),

                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("users")
                                .doc(FirebaseAuth.instance.currentUser?.uid
                                .toString())
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List<dynamic> listData = snapshot.data?["tasks"];
                                int tc = snapshot.data?['tasksCompleted'];
                                return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Tasks Left : ${listData.length}',
                                          style: TextStyle(fontFamily: 'Ubuntu_400'),
                                        ),
                                        Text(
                                          'Tasks Completed : ${tc}',
                                          style: TextStyle(fontFamily: 'Ubuntu_400'),
                                        ),
                                      ],
                                    ),
                                  );
                              } else {
                                return CircularProgressIndicator();
                              }
                            }),

                        SizedBox(
                          height: 16.0,
                        ),

                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("users")
                                .doc(FirebaseAuth.instance.currentUser?.uid
                                    .toString())
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List<dynamic> listData = snapshot.data?["tasks"];
                                return ListView.separated(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: listData.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      elevation: 2,
                                      child: Container(
                                        padding: EdgeInsets.all(12.0),
                                        child: Column(
                                          // mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Task ${index+1}',
                                                    // 'Task',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Ubuntu_500'),
                                                  ),
                                                  InkWell(
                                                      onTap: () {
                                                        List<dynamic> arr = listData;
                                                        arr.removeAt(index);
                                                        FirebaseFirestore.instance
                                                            .collection("users")
                                                            .doc(FirebaseAuth.instance.currentUser?.uid.toString())
                                                            .update({ "tasks": arr });
                                                        FirebaseFirestore.instance
                                                            .collection('users')
                                                            .doc(FirebaseAuth.instance.currentUser?.uid.toString())
                                                            .update({'tasksCompleted': FieldValue.increment(1)});


                                                        final snackBar = SnackBar(
                                                          /// need to set following properties for best effect of awesome_snackbar_content
                                                          elevation: 0,
                                                          behavior: SnackBarBehavior.floating,
                                                          backgroundColor: Colors.transparent,
                                                          content: AwesomeSnackbarContent(
                                                            title: 'Congratulations!',
                                                            message: 'Task completed successfully',
                                                            /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                                            contentType: ContentType.success,
                                                          ),
                                                        );

                                                        ScaffoldMessenger.of(context)
                                                          ..hideCurrentSnackBar()
                                                          ..showSnackBar(snackBar);


                                                      },
                                                      child:
                                                          Icon(Icons.task_alt)),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 4.0),
                                              child: Text(
                                                '${listData[index]['description']}',
                                                style: TextStyle(
                                                    fontFamily: 'Ubuntu_400'),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return Divider(
                                      height: 16,
                                    );
                                  },
                                );
                              } else {
                                return CircularProgressIndicator();
                              }
                            }),
                      ])),
            )),
          );
        });
  }
}