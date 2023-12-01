import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearning_admin_pannel/Screens/manage_courses.dart';
import 'package:elearning_admin_pannel/Screens/side_bar_widget.dart';
import 'package:elearning_admin_pannel/exercices/exerciceScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class AddExercice extends StatefulWidget {
  static const String id = 'add-exercice';
  AddExercice({Key? key}) : super(key: key);

  @override
  State<AddExercice> createState() => _AddExerciceState();
}

class _AddExerciceState extends State<AddExercice> {
  final TextEditingController _formLinkController = TextEditingController();
  final TextEditingController _name = TextEditingController();
  String selectedCourse="0";

  bool _isCategorieSelected = false;

  @override
  Widget build(BuildContext context) {
    SideBarWidget _sideBar = SideBarWidget();
    return 
    AdminScaffold(
       appBar: AppBar(
            title: Center(child: Text("Add Exercice")),
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
              ),),

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
            
              child: SingleChildScrollView(
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
                      controller: _formLinkController,
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
                      controller: _name,
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
                     SizedBox(height: 5,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(padding: EdgeInsets.all(8.0)),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                          .collection('courses')
                          .where('TeacherID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                          .snapshots(),
                          builder: (context, snapshot) {
                            List<DropdownMenuItem> categorieItems = [];
                            if (!snapshot.hasData) {
                              return const CircularProgressIndicator();
                            } else {
                              final categories = snapshot.data?.docs.reversed.toList();
                              categorieItems.add(
                                const DropdownMenuItem(
                                  value: "0",
                                  child: Text('Course selected'),
                                ),
                              );
                              for (var category in categories!) {
                                categorieItems.add(DropdownMenuItem(
                                  value: category["id"],
                                  child: Text(category['name']),
                                ));
                              }
                            }
                            return DropdownButton(
                              items: categorieItems,
                              onChanged: (categorieValue) {
                                setState(() {
                                  selectedCourse = categorieValue;
                                  _isCategorieSelected = true;
                                });
                              },
                              value: selectedCourse,
                              isExpanded: false,
                              hint: Text('Sélectionner une catégorie'),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        onPressed: _addExerciseLink,
                        child: Text('Add Exercise ',style: TextStyle(color: Colors.white),),
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

  void _addExerciseLink() async {
  String formLink = _formLinkController.text;
  String namee = _name.text;

  // Assuming 'courses' is your Firestore collection for courses
  // and 'exerciseLinks' is the subcollection for exercise links
  CollectionReference exerciseLinksCollection = FirebaseFirestore.instance
      .collection('courses')
      .doc(selectedCourse)
      .collection('exercise');

  await exerciseLinksCollection.add({
    'formLink': formLink,
    'name': namee,
    'timestamp': FieldValue.serverTimestamp(),
  }).then((_) {
    // Navigation after successful upload
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Exercice_Screen(), // Replace ExerciseScreen() with your Exercise Screen widget
      ),
    );
  }).catchError((error) {
    // Handle error if the upload fails
    print("Error adding exercise link: $error");
    // Optionally, you can show an error message to the user
  });
}

}

