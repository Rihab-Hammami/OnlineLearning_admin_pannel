import 'package:flutter/material.dart';
class ManageCoursesScreen extends StatefulWidget {
   static const String id="manage_courses_screen";

  @override
  State<ManageCoursesScreen> createState() => _ManageCoursesScreenState();
}

class _ManageCoursesScreenState extends State<ManageCoursesScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("manage courses screen",style: TextStyle(fontSize: 30,color: Colors.blue),),);
  }
}