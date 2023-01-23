import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Developer extends StatefulWidget {
  const Developer({Key? key}) : super(key: key);

  @override
  State<Developer> createState() => _DeveloperState();
}

class _DeveloperState extends State<Developer> {

  TextEditingController _messageController = new TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(child: Text('Developers of this App', style: TextStyle(fontFamily: 'Ubuntu_400'),)),
                ),
                SizedBox(height: 36,),
                CircleAvatar(
                  radius: 64,
                  backgroundImage: AssetImage('assets/images/developer.jpg'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: Text('spryzen_', style: TextStyle(fontFamily: 'Ubuntu_400'),),
                  ),
                ),

                SizedBox(height: 32.0,),
                Text('Want to contact with me ?? ', style: TextStyle(fontFamily: 'Ubuntu_400'),),
                SizedBox(height: 16,),
                TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Send a message',
                      hintStyle: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Ubuntu_300'),
                      labelText: 'Message',
                      labelStyle: TextStyle(
                          fontFamily: 'Ubuntu_400'),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF212529)),
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF212529)),
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF212529), width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      prefixIcon: Icon(
                        Icons.message,
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
                SizedBox(height: 16.0,),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        // onTap: (){},
                        child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: Color(0xFF212529),
                            ),
                            child: Center(
                              child:
                              Text('Send', style: TextStyle(fontFamily: 'Ubuntu_500', color: Colors.white),),
                            )
                        ),
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
