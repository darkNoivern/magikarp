import 'dart:async';

import 'package:flutter/material.dart';
import 'package:magikarp/main.dart';
import 'package:magikarp/screens/weather.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(Duration(seconds: 3), (){
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => MyHomePage(title: 'Flutter Demo Home Page'),
        ));
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF212529),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Image.asset('assets/images/splash.jpg'),
              ),
              SizedBox(height: 32,),
              Text('Welcome to my app', style: TextStyle(fontFamily: 'Ubuntu_400', fontSize: 16, color: Colors.white),)
            ],
        ),
      ),
    );
  }
}
