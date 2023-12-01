import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearning_admin_pannel/lessons/AddLesson.dart';
import 'package:elearning_admin_pannel/lessons/editLesson.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import '../Screens/side_bar_widget.dart';
import 'PdfViewerScreen.dart';

class LessonsScreen extends StatefulWidget {
  static const String id = 'lessons-screen';

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  Future<void> deleteLesson(String courseId, String lessonId) async {
    try {
      await FirebaseFirestore.instance
          .collection('courses')
          .doc(courseId)
          .collection('lessons')
          .doc(lessonId)
          .delete();
      print('Lesson deleted successfully.');
    } catch (e) {
      print('Error deleting lesson: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    SideBarWidget _sideBar = SideBarWidget();
    String pdfUrl = '';
    return Material(
      child: SingleChildScrollView(
        child: Container(
          width: 1100,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Lessons',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddLesson(),
                      ),
                    );
                  },
                  child: Text(
                    'Add Lesson',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 160, 208, 247),
                  ),
                ),
              ),
              const Divider(thickness: 3),

              // Fetch and display lessons
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('courses')
                    .where('TeacherID',
                        isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                    .snapshots(),
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
                      var lessonsCollection =
                          courseDoc.reference.collection('lessons');
                      return Card(
                        margin: EdgeInsets.all(8.0),
                        elevation: 4.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                courseDoc['name'] ?? '',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                            StreamBuilder(
                              stream: lessonsCollection.snapshots(),
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> lessonsSnapshot) {
                                if (lessonsSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                }

                                if (lessonsSnapshot.hasError) {
                                  return Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child:
                                        Text('Error: ${lessonsSnapshot.error}'),
                                  );
                                }

                                if (!lessonsSnapshot.hasData ||
                                    lessonsSnapshot.data!.docs.isEmpty) {
                                  return Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                        'No lessons available for this course.'),
                                  );
                                }

                                return Column(
                                  children: lessonsSnapshot.data!.docs
                                      .map((lessonDoc) {
                                    final lessonName =
                                        lessonDoc['name'] ?? ''; // Handle null value
                                    final lessonDuration =
                                        lessonDoc['duration'] ?? ''; // Handle null value
                                    final lessonImageUrl =
                                        lessonDoc['images'] ?? ''; // Handle null value

                                    return Card(
                                      margin: EdgeInsets.all(8.0),
                                      child: ListTile(
                                        title: Text('Title of lesson: $lessonName'),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Duration: $lessonDuration'),
                                            // Add more details here
                                          ],
                                        ),
                                        leading: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Image.network(
                                            lessonImageUrl,
                                            height: 60,
                                            width: 60,
                                          ),
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit),
                                              iconSize: 20,
                                              color: Color.fromARGB(
                                                  255, 223, 132, 126),
                                              onPressed: () {
                                                Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => EditLesson(
                                               id: lessonDoc.id, // Pass lesson id
                                            name: lessonDoc['name'], // Pass lesson name
                                            duration: lessonDoc['duration'], // Pass lesson duration
                                            fileUrl: lessonDoc['file_url'], // Pass file URL
                                            images: lessonDoc['images'], // Pass image URL
                                            teacherId: lessonDoc['TeacherID'], 
                                              ),),
                                            );
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete),
                                              iconSize: 20,
                                              color: Color.fromARGB(
                                                  255, 223, 132, 126),
                                              onPressed: () {
                                                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Confirm Deletion"),
                        content: Text("Are you sure you want to delete this exercise?"),
                        actions: <Widget>[
                          TextButton(
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text("Delete"),
                            onPressed: () {
                              // Perform delete action here
                              deleteLesson(courseDoc.id,lessonDoc.id);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                                              },
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          setState(() {
                                            pdfUrl =
                                                lessonDoc['file_url'] ?? ''; // Replace 'pdfUrl' with the actual field in your Firestore document containing the PDF URL
                                          });
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PdfViewerScreen(pdfUrl: pdfUrl),
                                            ),
                                          );
                                        },
                                        // Add more details or actions if needed
                                      ),
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                            Divider(thickness: 2),
                          ],
                        ),
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
