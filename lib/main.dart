import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearning_admin_pannel/Screens/home_screen.dart';
import 'package:elearning_admin_pannel/Screens/login_screen.dart';
import 'package:elearning_admin_pannel/Screens/manage_courses.dart';
import 'package:elearning_admin_pannel/Screens/manage_items.dart';
import 'package:elearning_admin_pannel/Screens/splash_screen.dart';
import 'package:elearning_admin_pannel/courses/AddCourses.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'lessons/LessonsScreen.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options:  FirebaseOptions(
        apiKey: "AIzaSyBs-z5MEP-BJnQSDUv--ZOsL2pDwwd6GQo",
        projectId: "elearningapp-6cb37",
        storageBucket: "elearningapp-6cb37.appspot.com",
        messagingSenderId: "515471366120",
        appId: "1:515471366120:web:3c8d29dc57a195d006765d",

    ),


  );
  FirebaseFirestore.instance.settings =
  const Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: Splash_screen.id,
      routes: {
        Splash_screen.id:(context)=>Splash_screen(),
        Home_screen.id:(context)=>Home_screen(),
        LoginScreen.id:(context)=>LoginScreen(),
        LessonsScreen.id: (context) => LessonsScreen(),
        ManageCoursesScreen.id:(context)=>ManageCoursesScreen(),
        ManageItemsScreen.id:(context)=>ManageItemsScreen(),


      

      },
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(child: Container(child: Text("Welcome to flutter web",style: TextStyle(fontSize: 30,color: Colors.blue),),),),
      )
    );
  }
}

