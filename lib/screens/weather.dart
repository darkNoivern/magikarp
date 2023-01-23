import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class Weather extends StatefulWidget {
  const Weather({Key? key}) : super(key: key);

  @override
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {


  TextEditingController _citynameController = new TextEditingController();
  String currentLocation = 'Georgia';
  String stringResponse = '';
  String location = 'Georgia';
  double latitude = 0.0;
  double longitude = 0.0;
  String wind = '2.6';
  String humidity = '0.0';
  String feelsLike = '0.0';
  String pressure = '0.0';
  String temp = '17.0';
  String icon = '50d';


  Future apiCallByCity() async{
    final response = await http.get(Uri.parse('http://api.openweathermap.org/data/2.5/weather?q=$location&units=metric&appid=32c612a4c1c744a7775b1473bd4ecc31'));
    if(response.statusCode == 200){
      var data = json.decode(response.body.toString());
      setState(() {
        stringResponse = response.body;
        location = data['name'].toString();
        currentLocation = data['name'].toString();
        wind = data['wind']['speed'].toString();
        pressure = data['main']['pressure'].toString();
        humidity = data['main']['humidity'].toString();
        temp = data['main']['temp'].toString();
        feelsLike = data['main']['feels_like'].toString();
        icon = data['weather'][0]['icon'];
      });
    }
  }

  Future apiCallByL() async{
    final response = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&units=metric&appid=32c612a4c1c744a7775b1473bd4ecc31'));
    if(response.statusCode == 200){
      var data = json.decode(response.body.toString());
      setState(() {
        stringResponse = response.body;
        location = data['name'].toString();
        currentLocation = "Latitude: $latitude" + " , " + "Logitude: $longitude";
        wind = data['wind']['speed'].toString();
        pressure = data['main']['pressure'].toString();
        humidity = data['main']['humidity'].toString();
        temp = data['main']['temp'].toString();
        feelsLike = data['main']['feels_like'].toString();
      });
    }
  }

  void _getCurrentLocation() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          currentLocation = "Permission Denied";
        });
      } else {
        var position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        setState(() {
          latitude = position.latitude;
          longitude = position.longitude;
          currentLocation = "Latitude: ${position.latitude}" + " , " + "Logitude: ${position.longitude}";
        });
        apiCallByL();
        currentLocation = "Latitude: ${position.latitude}" + " , " + "Logitude: ${position.longitude}";
      }
    } else {
      var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
        currentLocation = "Latitude: ${position.latitude}" + " , " + "Logitude: ${position.longitude}";
      });
      apiCallByL();
      currentLocation = "Latitude: ${position.latitude}" + " , " + "Logitude: ${position.longitude}";
    }
  }

  @override
  void initState() {
    apiCallByCity();
    super.initState();
  }


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
        body:
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text('Weather Screen', style: TextStyle(fontFamily: 'Ubuntu_400'),),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                          controller: _citynameController,
                          decoration: InputDecoration(
                            hintText: 'Name a city',
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Ubuntu_300'),
                            labelText: 'City',
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
                              Icons.place_outlined,
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
                    SizedBox(width: 8.0,),
                    Expanded(child: InkWell(
                      onTap: (){
                        setState(() {
                          location = _citynameController.text;
                        });
                        apiCallByCity();
                        FocusScopeNode currentFocus = FocusScope.of(context);
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
                        child: Center(child: Text('Submit', style: TextStyle(color: Colors.white, fontFamily: 'Ubuntu_500',),)),
                      ),
                    ))
                  ],
                ),
                Container(
                    margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Text('--- OR ---', style: TextStyle(fontFamily: 'Ubuntu_400'),)
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: SingleChildScrollView(
                        child: Container(
                            height: 64,
                            decoration: BoxDecoration(color: Colors.teal[50]),
                            padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.location_on),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Location',
                                            style: TextStyle(fontFamily: 'Ubuntu_400'),
                                          ),
                                          (currentLocation != null)
                                              ? Text(currentLocation, style: TextStyle(fontFamily: 'Ubuntu_300'),)
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      ),
                    ),
                    SizedBox(width: 8.0,),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _getCurrentLocation();
                        },
                        // splashColor: Colors.deepPurple.shade50,focusColor: Colors.deepPurple.shade50,
                        child: Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: Color(0xFF212529),
                            ),
                            height: 64,
                            child: Center(child: Text("Get Current Location", style: TextStyle(color: Colors.white, fontFamily: 'Ubuntu_500',),))),
                      ),
                    )
                  ],
                ),

                Container(
                    margin: EdgeInsets.only(top: 32.0),
                    child: Image.network('http://openweathermap.org/img/wn/$icon@4x.png', height: 100, width: 100,)),
                Container(
                    child: Text('$temp°C', style: TextStyle(fontFamily: 'Ubuntu_500', fontSize: 32),)),
                Container(
                    margin: EdgeInsets.only(top: 8.0, bottom: 16.0),
                    child: Text(location, style: TextStyle(fontFamily: 'Ubuntu_400', fontSize: 24.0),)
                ),

                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 16.0),
                      child: Row(
                        children: [
                          Expanded(child: Center(child: Container(child: Text('Wind : $wind', style: TextStyle(fontFamily: 'Ubuntu_300', fontSize: 16.0),)))),
                          Expanded(child: Center(child: Container(child: Text('Feels Like : $feelsLike°C', style: TextStyle(fontFamily: 'Ubuntu_300', fontSize: 16.0),)))),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(child: Center(child: Container(child: Text('Pressure : $pressure', style: TextStyle(fontFamily: 'Ubuntu_300', fontSize: 16.0),)))),
                        Expanded(child: Center(child: Container(child: Text('Humidity : $humidity', style: TextStyle(fontFamily: 'Ubuntu_300', fontSize: 16.0),)))),
                      ],
                    )
                  ],
                ),

                // Text(stringResponse.toString()),

              ],
            ),
          ),
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.,
        floatingActionButton: Container(
          margin: EdgeInsets.only(bottom: 56.0),
          child: FloatingActionButton(
            onPressed: () {
              apiCallByCity();
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            tooltip: 'Refresh',
            child: Center(child: Icon(Icons.refresh_rounded),),
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
