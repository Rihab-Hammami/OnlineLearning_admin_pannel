import 'package:flutter/material.dart';

import '../courses/AddCourses.dart';
class ManageCoursesScreen extends StatefulWidget {
   static const String id="manage_courses_screen";

  @override
  State<ManageCoursesScreen> createState() => _ManageCoursesScreenState();
}

class _ManageCoursesScreenState extends State<ManageCoursesScreen> {
  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
        child: Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(10),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    const Text(
    'Produits',
    style: TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w700,
    fontSize: 36,
    ),
    ),
          Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddCourse(),
                  ),
                );
              },
                child: Text('Ajouter Produit',style: TextStyle(color: Colors.black),),
                style: ElevatedButton.styleFrom(primary:Colors.deepOrange),

              ),
          ),
          ],
    ),
    ),
    );


  }
}