import 'dart:convert';
import 'dart:io';  // Import File from dart:io

import 'package:elearning_admin_pannel/Screens/home_screen.dart';
import 'package:elearning_admin_pannel/Screens/manage_items.dart';
import 'package:elearning_admin_pannel/Screens/side_bar_widget.dart';
import 'package:elearning_admin_pannel/lessons/LessonsScreen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Screens/manage_courses.dart';
import '../models/Course.dart';
import 'package:flutter/services.dart';

class AddLesson extends StatefulWidget {

  @override
  State<AddLesson> createState() => _AddLessonState();
}

class _AddLessonState extends State<AddLesson> {
  String imgUrl = '';
  String imgUrl2 = '';
  late File file;
  bool _visible = false;
  bool _isButtonVisible = true;
  bool _isCategorieSelected = false;
  double _rating = 0;  bool _isConfirmed = false;
  String? pickedFileName;

  final _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController duration = TextEditingController();
  CollectionReference ref = FirebaseFirestore.instance.collection('lessons');
  String selectedCourse="0";


  Future<void> _openFileExplorer() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        final pickedFileUrl = await uploadToFirebase(result.files.first);

        setState(() {
          pickedFileName = result.files.first.name;
        });

        addLesson(pickedFileUrl,imgUrl);
      } else {
        print('File picking canceled.');
      }
    } catch (e) {
      print('Error while picking a file: $e');
    }
  }

  Future<String> uploadToFirebase(PlatformFile file) async {
    final fileBytes = file.bytes;
    final date = DateTime.now().millisecondsSinceEpoch;

    try {
      FirebaseStorage fs = FirebaseStorage.instance;
      var snapshot = await fs.ref().child('lessons/$date').putData(fileBytes!);
      String downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        imgUrl = downloadUrl;
      });

      return downloadUrl;
    } catch (error) {
      print('Error uploading to Firebase: $error');
      throw error;
    }
  }
  Future<void> uploadToFirebaseImag() async {
    if (_visible && file != null && name.text.isNotEmpty) {
      try {
        FirebaseStorage fs = FirebaseStorage.instance;
        int date = DateTime.now().millisecondsSinceEpoch;
        var snapshot = await fs.ref().child('lessons/$date').putBlob(file!);
        String DownloadImg = await snapshot.ref.getDownloadURL();

        setState(() {
          imgUrl2 = DownloadImg;
        });
      } catch (error) {
      }
    }
  }

  Future<void> addLesson(String fileDownloadUrl,String DownloadImg) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final data = {
      'name': name.text,
      'duration': duration.text,
      'file_url': fileDownloadUrl,
      'images': DownloadImg,// Add the file download URL to the data
      'TeacherID': currentUser?.uid,
      'timestamp': FieldValue.serverTimestamp(),
    };

    // Add the lesson to the 'lessons' subcollection of the selected course
    await FirebaseFirestore.instance
        .collection('courses')
        .doc(selectedCourse)
        .collection('lessons')
        .add(data)
        .then((value) {
      // Update the lesson document with the lesson ID
      value.update({
        "id": value.id,
      });
    });
  }
  Future<void> selectImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image, // Set the type to image
      );

      if (result != null) {
        final fileBytes = result.files.first.bytes;

        setState(() {
          _visible = true;
          imgUrl2 = 'data:image/jpeg;base64,${base64Encode(fileBytes!)}';
          _isButtonVisible = false;
        });
      } else {
        // User canceled the file picker
        print('File picking canceled.');
      }
    } catch (e) {
      print('Error while picking an image: $e');
    }
  }
 /* Future<void> selectImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image, // Set the type to image
      );

      if (result != null) {
        final fileBytes = result.files.first.bytes;

        setState(() {
          _visible = true;
          imgUrl = 'data:image/jpeg;base64,${base64Encode(fileBytes!)}';
          _isButtonVisible = false;
        });
      } else {
        // User canceled the file picker
        print('File picking canceled.');
      }
    } catch (e) {
      print('Error while picking an image: $e');
    }
  }*/
 /* Future<void> uploadToFirebase() async {
    if (_visible && file != null && name.text.isNotEmpty) {
      try {
        FirebaseStorage fs = FirebaseStorage.instance;
        int date = DateTime.now().millisecondsSinceEpoch;
        var snapshot = await fs.ref().child('lessons/$date').putBlob(file!);
        String downloadUrl = await snapshot.ref.getDownloadURL();
        await addLesson(
          downloadUrl,


        );
        setState(() {
          imgUrl = downloadUrl;
        });
      } catch (error) {
      }
    }
  }*/

  @override
  Widget build(BuildContext context) {
    SideBarWidget _sideBar = SideBarWidget();
    return
      AdminScaffold(
          appBar: AppBar(
            title: Center(child: Text("Add Lesson")),
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

          body:  Center(
            child: Container(
              width: 700,

              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                     Container(
                        width: 300,
                        height: 350,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.blueAccent),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: _visible
                                    ? Image.network(
                                  imgUrl2,
                                  height: 200,
                                  width: 200,
                                  fit: BoxFit.cover,
                                )
                                    : Container(),
                              ),
                              Container(

                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF00B4DB), // #00B4DB color
                                      Color(0xFFC9D6FF), // #C9D6FF color
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  // Add additional properties for the Container's decoration as needed
                                ),
                                child: MaterialButton(
                                  onPressed: () {
                                    selectImage();
                                  },
                                  child: Text("Select Image"),
                                  textColor: Colors.white,
                                  color: Colors.transparent, // Set button's color to transparent to show the gradient background
                                  elevation: 0, // Remove the button's elevation
                                  // Add additional properties for the MaterialButton as needed
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      SizedBox(
                          height: 20.0),
                      Padding(padding: const EdgeInsets.all(8.0),
                        child:  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: 10,),
                            TextFormField(
                              controller: name,
                              decoration: InputDecoration(
                                hintText: 'Lesson Name',
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the  Name of course!';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _openFileExplorer();
                        },
                        child: Text('Select File'),
                      ),
                      SizedBox(height: 20),
                      pickedFileName != null
                          ? Text('File picked: $pickedFileName')
                          : Container(),

                      Padding(padding: const EdgeInsets.all(8.0),
                        child:
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Duration',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: 10,),
                            TextFormField(
                              controller: duration,
                              decoration: InputDecoration(
                                hintText: 'duration ',
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

                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the duration Date !';
                                }
                                return null;
                              },

                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 18),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Category selection
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(padding: EdgeInsets.all(8.0)),
                              StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance.collection('courses').snapshots(),
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
                        ],),
                      SizedBox(height: 18),




                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate() && pickedFileName != null) {
                            _submitData();
                          } else {
                            // Handle form validation errors or file not selected
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.blue),
                        ),
                        child: Text(
                          "Submit",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ),



                      SizedBox(height: 12,),
                    ],
                  ),
                ),
              ),
            ),

          ));
  }
  bool _isFormFilled() {
    return name.text.isNotEmpty &&

        duration.text.isNotEmpty ;

    // Add other fields validation here
  }
  void _submitData() {
    if (_formKey.currentState!.validate()) {
      addLesson(imgUrl,imgUrl2).then((_) {
        // Show a success dialog after successful submission
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Addition successful'),
              content: Text('Your course has been successfully added.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LessonsScreen()),
                    );
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }).catchError((error) {
        // Handle any errors that occur during submission
        print('Error occurred: $error');
      });
    } else {
      // Form contains validation errors, do not submit
      print('Form contains validation errors');
    }
  }






}