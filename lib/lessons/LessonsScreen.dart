import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearning_admin_pannel/lessons/AddLesson.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import '../Screens/side_bar_widget.dart';
import 'PdfViewerScreen.dart';



class LessonsScreen  extends StatefulWidget {
  static const String id = 'lessons-screen';

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen > {
  @override
  Widget build(BuildContext context) {
    SideBarWidget _sideBar = SideBarWidget();
    String pdfUrl = '';
    return Material(
      child: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddLesson(),
                    ),
                  );
                },
                  child: Text('Add Lesson',style: TextStyle(color: Colors.black),),
                  style: ElevatedButton.styleFrom(),

                ),
              ),

              SizedBox(height: 30),
              const Text(
                'All Lessons',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
              ),

              Divider(thickness: 2),
              // Fetch and display lessons
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('courses').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text('No courses available.');
                  }

                  return Column(
                    children: snapshot.data!.docs.map((courseDoc) {
                      // Access the lessons subcollection of each course
                      var lessonsCollection = courseDoc.reference.collection('lessons');
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            courseDoc['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 24,
                            ),
                          ),
                          StreamBuilder(
                            stream: lessonsCollection.snapshots(),
                            builder: (context, AsyncSnapshot<QuerySnapshot> lessonsSnapshot) {
                              if (lessonsSnapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              }

                              if (lessonsSnapshot.hasError) {
                                return Text('Error: ${lessonsSnapshot.error}');
                              }

                              if (!lessonsSnapshot.hasData || lessonsSnapshot.data!.docs.isEmpty) {
                                return Text('No lessons available for this course.');
                              }

                              return Column(
                                children: lessonsSnapshot.data!.docs.map((lessonDoc) {
                                  return ListTile(
                                    title: Text('title of lesson : ${lessonDoc['name']}'),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Duration: ${lessonDoc['duration']}'),
                                        // You can add more details here
                                      ],
                                    ),
                                    leading:  ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(
                                        (lessonDoc['images'] as String),
                                        height: 60,
                                        width: 60,
                                      ),
                                    ),
                                    onTap: () {
                                      // Set the PDF URL when the ListTile is tapped
                                      setState(() {
                                        pdfUrl = lessonDoc['file_url']; // Replace 'pdfUrl' with the actual field in your Firestore document containing the PDF URL
                                      });
                                      // Open a new screen to display the PDF
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PdfViewerScreen(pdfUrl: pdfUrl),
                                        ),
                                      );
                                    },  // Add more details or actions if needed
                                  );
                                }).toList(),
                              );
                            },
                          ),
                          Divider(thickness: 2),
                        ],
                      );
                    }).toList(),
                  );
                },
              ),

              // Add the rest of your widget tree here
            ],
          ),
        ),
      ),
    );

  }
}