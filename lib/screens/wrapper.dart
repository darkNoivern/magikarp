import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:magikarp/screens/task.dart';
import 'package:magikarp/screens/weather.dart';
import 'bmi.dart';
import 'developer.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  Widget _child = Weather();
  final auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: ClipRect(
        child: Scaffold(
          extendBody: true,
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Flutter Demo', style: TextStyle(fontFamily: 'Ubuntu_400'),),
                InkWell(
                  onTap: (){
                    auth.signOut().then((value) => {

                    }).onError((error, stackTrace) => {
                      // debugPrint(error);
                    });
                  },
                  child: Text('Logout', style: TextStyle(fontFamily: 'Ubuntu_300'),),
                )
              ],
            ),
          ),
          body: _child,
          bottomNavigationBar: FluidNavBar(

              animationFactor: 0.5,
              icons: [
                FluidNavBarIcon(
                    icon: Icons.ac_unit_rounded, backgroundColor: Color(0xFF4285F4)),
                FluidNavBarIcon(
                    icon: Icons.watch_later_outlined, backgroundColor: Color(0xFFEC4134)),
                FluidNavBarIcon(
                    icon: Icons.task_alt_rounded, backgroundColor: Color(0xFFFCBA02)),
                FluidNavBarIcon(
                    icon: Icons.adb_rounded, backgroundColor: Color(0xFF34A950)),
              ],
              onChange: (int index) {
                setState(() {
                  switch (index) {
                    case 0:
                      _child = Weather();
                      break;
                    case 1:
                      _child = BMICalculator();
                      break;
                    case 2:
                      _child = TaskMaster();
                      break;
                    case 3:
                      _child = Developer();
                      break;
                  }
                  _child = AnimatedSwitcher(
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    duration: Duration(milliseconds: 500),
                    child: _child,
                  );
                });},
              style: FluidNavBarStyle(
                barBackgroundColor: Color(0xFF212529),
                iconUnselectedForegroundColor: Colors.white,
              )
          ),
        ),
      ),
    );
  }
}
