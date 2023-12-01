import 'package:elearning_admin_pannel/Screens/manage_courses.dart';
import 'package:elearning_admin_pannel/Screens/side_bar_widget.dart';
import 'package:elearning_admin_pannel/exercices/exerciceScreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class EditExercise extends StatefulWidget {
  final String courseId;
  final String exerciseId;
  final String initialFormLink;
  final String initialName;

  EditExercise({
    required this.courseId,
    required this.exerciseId,
    required this.initialFormLink,
    required this.initialName,
  });

  @override
  _EditExerciseState createState() => _EditExerciseState();
}

class _EditExerciseState extends State<EditExercise> {
  late TextEditingController formLinkController;
  late TextEditingController nameController;
  late DocumentReference _reference;
  String selectedCourse = "0";
  bool _isCategorySelected = false;

  @override
  void initState() {
    formLinkController = TextEditingController(text: widget.initialFormLink);
    nameController = TextEditingController(text: widget.initialName);
    _reference = FirebaseFirestore.instance
        .collection('courses')
        .doc(widget.courseId)
        .collection('exercise')
        .doc(widget.exerciseId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SideBarWidget _sideBar = SideBarWidget();
    return AdminScaffold(
      appBar: AppBar(
        title: Center(child: Text("Edit Exercise")),
        backgroundColor: Colors.grey,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF00B4DB), // #00B4DB color
                Color(0xFFC9D6FF), // #C9D6FF color
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
          ),
        ),
      ),
       sideBar: _sideBar.sideBarMenus(context, ManageCoursesScreen.id),
      body: Center(
        child: Container(
          width: 700,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                      'Add Exercise Link',
                       style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 18,
                              ),
                    ),
                     SizedBox(height: 10,),
                    TextField(
                      controller: formLinkController,
                      decoration: InputDecoration(
                                hintText: 'Google Form Link',
                                hintStyle: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 14,

                                ),
                                filled: true, // ajouter un fond rempli de couleur
                                fillColor: Colors.grey[200], // définir la couleur de l'arrière-plan
                                border: OutlineInputBorder( // définir une bordure de rectangle
                                  borderRadius: BorderRadius.circular(8.0), // personnaliser le rayon des coins du rectangle
                                  borderSide: BorderSide.none, // supprimer la bordure de ligne
                                ),
                              ),
                    ),
                    Text(
                      'name of Exercise ',
                       style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 18,
                              ),
                    ),
                     SizedBox(height: 10,),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                                hintText: 'Exercice Name',
                                hintStyle: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 14,

                                ),
                                filled: true, // ajouter un fond rempli de couleur
                                fillColor: Colors.grey[200], // définir la couleur de l'arrière-plan
                                border: OutlineInputBorder( // définir une bordure de rectangle
                                  borderRadius: BorderRadius.circular(8.0), // personnaliser le rayon des coins du rectangle
                                  borderSide: BorderSide.none, // supprimer la bordure de ligne
                                ),
                              ),
                    ),
                SizedBox(height: 16),
                Text(
                  'Select Course',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: EdgeInsets.all(8.0)),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('courses')
                          .where('TeacherID',
                              isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        List<DropdownMenuItem> categoryItems = [];
                        if (!snapshot.hasData) {
                          return const CircularProgressIndicator();
                        } else {
                          final categories =
                              snapshot.data?.docs.reversed.toList();
                          categoryItems.add(
                            const DropdownMenuItem(
                              value: "0",
                              child: Text('Course selected'),
                            ),
                          );
                          for (var category in categories!) {
                            categoryItems.add(DropdownMenuItem(
                              value: category["id"],
                              child: Text(category['name']),
                            ));
                          }
                        }
                        return DropdownButton(
                          items: categoryItems,
                          onChanged: (categoryValue) {
                            setState(() {
                              selectedCourse = categoryValue;
                              _isCategorySelected = true;
                            });
                          },
                          value: selectedCourse,
                          isExpanded: false,
                          hint: Text('Select a category'),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      String formLink = formLinkController.text;
                      String name = nameController.text;
                  
                      Map<String, dynamic> dataToUpdate = {
                        'formLink': formLink,
                        'name': name,
                      };
                  
                      _reference.update(dataToUpdate);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Exercice_Screen();
                          },
                        ),
                      );
                  
                      Navigator.pop(context);
                    },
                    child: Text('Update Exercise',style: TextStyle(color:Colors.white),),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 98, 183, 252)),
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
