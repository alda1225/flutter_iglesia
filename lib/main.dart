import 'package:flutter/material.dart';
import 'package:flutter_church/src/constant/constantes.dart';
import 'package:flutter_church/src/pages/page_subirImagen.dart';
import 'package:flutter_church/src/pages/welcome_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Radio la cosecha',
       routes: {
        // When navigating to the "/second" route, build the SecondScreen widget.
        'imagen': (context) => ImagenUpload(),
      },
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: kBackgroundColor,
        textTheme: TextTheme(
          display1: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontFamily: "Poppins"),
          button: TextStyle(color: kPrimaryColor),
          headline: TextStyle(
              color: Colors.white, fontWeight: FontWeight.normal, fontSize: 16,fontFamily: "Poppins"),
          display2: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16,fontFamily: "Poppins"),
        ),
      ),
      home: WelcomePage(),
      
    );
  }
}
