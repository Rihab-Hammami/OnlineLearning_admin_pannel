import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearning_admin_pannel/Screens/side_bar_widget.dart';
import 'package:elearning_admin_pannel/exercices/AddExercice.dart';
import 'package:elearning_admin_pannel/exercices/WebViewPage.dart';
import 'package:elearning_admin_pannel/exercices/edit_exercice.dart';
import 'package:elearning_admin_pannel/lessons/PdfViewerScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Exercice_Screen extends StatefulWidget {
static const String id = 'exercice-screen';

  @override
  State<Exercice_Screen> createState() => _Exercice_ScreenState();
}

class _Exercice_ScreenState extends State<Exercice_Screen> {
  Future<void> deleteExercice(String courseId, String exerciseId) async {
  try {
    // Reference the 'lessons' collection under the specific 'courseId' and delete the lesson document using 'lessonId'
    await FirebaseFirestore.instance
        .collection('courses')
        .doc(courseId)
        .collection('exercise')
        .doc(exerciseId)
        .delete();
    print('exercice deleted successfully.');
  } catch (e) {
    print('Error deleting exercice: $e');
  }
}
  @override
  Widget build(BuildContext context) {
     SideBarWidget _sideBar = SideBarWidget();
    String Url = '';
    return Material(
            child: SingleChildScrollView(
              child:Container(
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
                      'Exercices',
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
                              builder: (context) => AddExercice(),
                            ),
                          );
                        },
                        child: Text('Add Exercice',
                          style: TextStyle(color: Colors.white),),
                        style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 160, 208, 247)),
                      ),
                    ),
                    const Divider(thickness: 3,),


                    ////////display exercices///////
                     StreamBuilder(
               stream: FirebaseFirestore.instance
              .collection('courses')
              .where('TeacherID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
              .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text('No exercise available.');
                  }

                return Column(
                  children: snapshot.data!.docs.map((courseDoc) {
                    // Access the lessons subcollection of each course
                    var exerciseLinksCollection = courseDoc.reference.collection('exercise');
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       Text(
                          courseDoc['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                            color: Colors.black, 

                          ),
                        ),

                        StreamBuilder(
                          stream: exerciseLinksCollection.snapshots(),
                          builder: (context, AsyncSnapshot<QuerySnapshot> exerciseSnapshot) {
                            if (exerciseSnapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }

                            if (exerciseSnapshot.hasError) {
                              return Text('Error: ${exerciseSnapshot.error}');
                            }

                            if (!exerciseSnapshot.hasData || exerciseSnapshot.data!.docs.isEmpty) {
                              return Text('No exercice available for this course.');
                            }

                            return Row(
                                children: exerciseSnapshot.data!.docs.map((exerciseDoc) {
                                  return Card(
  elevation: 3, // Set the elevation for the card
  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
  child: InkWell(
    onTap: () {
      setState(() {
        Url = exerciseDoc['formLink']; // Replace 'formLink' with the actual field in your Firestore document containing the link
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WebViewPage(formLink: Url),
        ),
      );
    },
    child: Padding(
      padding: EdgeInsets.all(25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                exerciseDoc['name'], // Replace 'name' with the actual field in your Firestore document containing the exercise name
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Add more widgets if needed
            ],
          ),
          SizedBox(width: 10,),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                iconSize: 20,
                color: Colors.green, // Customize the color of the edit icon
                onPressed: () {
                  // Implement edit functionality
                  Navigator.push(
                                             context,
                                              MaterialPageRoute(builder: (context) => EditExercise(
                                                courseId: courseDoc.reference.parent.id,
                                              exerciseId: exerciseDoc.id,
                                              initialName: exerciseDoc['name'],
                                              initialFormLink: exerciseDoc['formLink'],
                                              ),),
                                            );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                iconSize: 20,
                color: Color.fromARGB(255, 223, 132, 126), // Customize the color of the delete icon
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
                              deleteExercice(courseDoc.id,exerciseDoc.id);
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
        ],
      ),
    ),
  ),
);

                                }).toList(),
                              );

                          },
                        ),

                      ],
                    );
                  }).toList(),
                );
              },
            ),
            
             ]
             ),
        ),
      ),
    );
  }
}