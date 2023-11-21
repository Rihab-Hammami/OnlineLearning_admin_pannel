import 'dart:html';

import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../Screens/manage_courses.dart';
import '../models/Course.dart';
import 'package:flutter/services.dart';

class AddCourse extends StatefulWidget {

  @override
  State<AddCourse> createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
  String imgUrl = '';
 late File file;
  bool _visible = false;
  bool _isButtonVisible = true;

  bool _isConfirmed = false;
  double _rating = 0;
  final _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController session = TextEditingController();
  TextEditingController review = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController duration = TextEditingController();
  DateTime _selecteddate = DateTime.now();
  CollectionReference ref = FirebaseFirestore.instance.collection('courses');
  Future<void> addCourse(String downloadUrl) async {

    final currentUser = FirebaseAuth.instance.currentUser;
    final data = {
      'name': name.text,
      'description': description.text,
      'session': session.text,
      'review': review.text,
      'price': price.text,
      'duration': duration.text,
      'images':downloadUrl,

      'timestamp': FieldValue.serverTimestamp(),
      'TeacherID': currentUser?.uid,
      'favourites':[],
    };
    ref.add(data).then((value) {
      ref.doc(value.id).update({
        "id": value.id
      });
    });
  }
  Future<void> selectImage() async {
    FileUploadInputElement input = FileUploadInputElement()..accept = 'image/*';
    input.click();
    input.onChange.listen((event) async {
      print("File selected");
      final file = input.files?.first;
      final reader = FileReader();
      reader.readAsDataUrl(file!);
      reader.onLoadEnd.listen((event) async {
        print("File loaded");
        if (file != null) {
          setState(() {
            _visible = true;
            imgUrl = reader.result as String;
            this.file = file ;
            _isButtonVisible = false;
          });
        }
      });
    });
  }
  Future<void> uploadToFirebase() async {
    if (_visible && file != null && name.text.isNotEmpty) {
      try {
        FirebaseStorage fs = FirebaseStorage.instance;
        int date = DateTime.now().millisecondsSinceEpoch;
        var snapshot = await fs.ref().child('courses/$date').putBlob(file!);
        String downloadUrl = await snapshot.ref.getDownloadURL();
        await addCourse(
          downloadUrl,


        );
        setState(() {
          imgUrl = downloadUrl;
        });
      } catch (error) {
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Add Course")),
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
                              imgUrl,
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
                            hintText: 'Course Name',
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
                  Padding(padding: const EdgeInsets.all(8.0),
                    child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'session',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 10,),
                        TextFormField(
                          controller: session,
                          decoration: InputDecoration(
                            hintText: 'session',
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
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the session !';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  Padding(padding: const EdgeInsets.all(8.0),
                    child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'price',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 10,),
                       
              
                        TextFormField(
                          controller: price,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          decoration: InputDecoration(
                            hintText: 'Price',
                            hintStyle: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 14,
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the price!';
                            }
                            return null;
                          },
                        )
              
              
                      ],
                    ),
                  ),
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
                  Padding(padding: const EdgeInsets.all(8.0) ),
                  SizedBox(height: 18),
                  Padding(padding: const EdgeInsets.all(8.0),
                    child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 10,),
                        // définir la hauteur souhaitée du TextFormField
                        TextFormField(
                          controller: description,
                          decoration: InputDecoration(
              
                            contentPadding: EdgeInsets.symmetric(vertical: 55.0), // définir la marge interne de la zone de saisie
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
                          maxLines: null, // permet à l'utilisateur d'écrire autant de lignes qu'il souhaite
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the event description';
                            }
                            return null;
                          },
                        ),
              
                      ],
                    ),
                  ),
                   
                  SizedBox(height: 18),
                 
              
                    ElevatedButton(
                      onPressed: () {
                         _isFormFilled() ? _submitData : null;
                          if (_formKey.currentState!.validate()) {
                          // All form fields are valid, proceed with submission
                          _submitData();
                        } else {
                          // Form contains validation errors, do not submit
                          print('Form contains validation errors');
                        }
                    if (_isFormFilled()) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Confirmation'),
                          content: Text('Do you really want to submit?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  _isConfirmed = true;
                                });
                                _submitData(); // Call _submitData() after confirming
                              },
                              child: Text('Submit'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Fields Empty'),
                          content: Text('Please fill in all the required fields.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          _isConfirmed ? Colors.green : CupertinoColors.systemGrey,
                        ),
                      ),
                      child: Text(
                        _isConfirmed ? "Submit" : "Submit",
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
        session.text.isNotEmpty &&
        price.text.isNotEmpty &&
        duration.text.isNotEmpty &&
        description.text.isNotEmpty;
    // Add other fields validation here
  }
void _submitData() {
  if (_isConfirmed) {
    addCourse(imgUrl);
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
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  } else {
    // Handle cancellation or unconfirmed submission
  }
}




}