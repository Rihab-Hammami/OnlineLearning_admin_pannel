import 'dart:async';

import 'package:elearning_admin_pannel/Screens/login_screen.dart';
import 'package:flutter/material.dart';
class Splash_screen extends StatefulWidget {
 static const String id="splash_screen";

  @override
  State<Splash_screen> createState() => _Splash_screenState();
}

class _Splash_screenState extends State<Splash_screen> {

  @override
  void initState() {
    Timer(Duration(seconds: 5), () =>Navigator.pushReplacementNamed(context, Login_screen.id));
     
   
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 200,
          width: 200,
          child: Image.asset("assets/images/Online_world.png")),
      ),
    );
  
  }
}
 