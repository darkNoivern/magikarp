// import 'dart:html';
import 'package:flutter/material.dart';

class BMICalculator extends StatefulWidget {
  const BMICalculator({Key? key}) : super(key: key);

  @override
  State<BMICalculator> createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  TextEditingController _weightController = new TextEditingController();
  TextEditingController _heightController = new TextEditingController();
  double bmi = 0.0;
  bool _showBmi = false;
  String _msg = '';

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
        body: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'BMI',
                  style: TextStyle(fontFamily: 'Ubuntu_400'),
                ),
              ),
              TextField(
                  controller: _weightController,
                  decoration: InputDecoration(
                    hintText: 'Weight in KGs',
                    hintStyle:
                        TextStyle(color: Colors.grey, fontFamily: 'Ubuntu_300'),
                    labelText: 'Weight',
                    labelStyle: TextStyle(fontFamily: 'Ubuntu_400'),
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
                      borderSide:
                          BorderSide(color: Color(0xFF212529), width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    prefixIcon: Icon(
                      Icons.watch_later_outlined,
                      color: Color(0xFF212529),
                    ),
                  ),
                  textAlign: TextAlign.left,
                  keyboardType: TextInputType.number,
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
                  controller: _heightController,
                  decoration: InputDecoration(
                    hintText: 'Height in Metres',
                    hintStyle:
                        TextStyle(color: Colors.grey, fontFamily: 'Ubuntu_300'),
                    labelText: 'Height',
                    labelStyle: TextStyle(fontFamily: 'Ubuntu_400'),
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
                      borderSide:
                          BorderSide(color: Color(0xFF212529), width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    prefixIcon: Icon(
                      Icons.escalator_sharp,
                      color: Color(0xFF212529),
                    ),
                  ),
                  textAlign: TextAlign.left,
                  keyboardType: TextInputType.number,

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
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        double bmix = 0.0;
                        double weight =
                            double.parse(_weightController.text.toString());
                        double height =
                            double.parse(_heightController.text.toString());
                        bmix = weight / (height * height);
                        setState(() {
                          _showBmi = true;
                          bmi = bmix;
                        });

                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }

                      },
                      child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Color(0xFF212529),
                          ),
                          child: Center(
                            child: Text(
                              'Calculate',
                              style: TextStyle(
                                  fontFamily: 'Ubuntu_500',
                                  color: Colors.white),
                            ),
                          )),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 64,
              ),
              if (_showBmi)
                Container(
                  child: Text(
                    '$bmi',
                    style: TextStyle(fontSize: 36, fontFamily: 'Ubuntu_400'),
                  ),
                ),
              if (_showBmi)
                Container(
                  child: Text(
                    '$_msg',
                    style: TextStyle(fontFamily: 'Ubuntu_400'),
                  ),
                ),
            ],
          ),
        ),
        floatingActionButton: Container(
          margin: EdgeInsets.only(bottom: 56.0),
          child: FloatingActionButton(
            onPressed: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
              setState(() {
                _showBmi = false;
                _heightController.clear();
                _weightController.clear();
              });
            },
            tooltip: 'Refresh',
            child: Center(
              child: Icon(Icons.refresh_rounded),
            ),
          ),
        ),
      ),
    );
  }
}
