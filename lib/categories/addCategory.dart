// ignore_for_file: sort_child_properties_last

import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'dart:html' as html;
import 'dart:io' as io;

import '../Screens/side_bar_widget.dart';
import '../models/Category.dart';
import 'CategoryScreen.dart';



class AddEditCategorie extends StatefulWidget {
  static const String id = 'categorieEdit-screen';


  @override
  State<AddEditCategorie> createState() => _AddEditCategorieState();
}

class _AddEditCategorieState extends State<AddEditCategorie> {
  TextEditingController libelleController = TextEditingController();
  bool _isButtonVisible = true;
  bool _visible = false;
  String imgUrl = '';
  html.File? file;
  @override
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


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
    if (_visible && file != null && libelleController.text.isNotEmpty) {
      try {
        FirebaseStorage fs = FirebaseStorage.instance;
        int date = DateTime.now().millisecondsSinceEpoch;
        var snapshot = await fs.ref().child('categories/$date').putBlob(file!);
        String downloadUrl = await snapshot.ref.getDownloadURL();
        await addDataToFirestore(downloadUrl, libelleController.text);
        setState(() {
          imgUrl = downloadUrl;
        });
      } catch (error) {
      }
    }
  }

  Future<void> addDataToFirestore(String imageUrl, String libelle) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    Category category = Category(imageUrl: imageUrl, libelle: libelle);

    await firestore.collection('categories').add(category.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(right: 600),
        child: Form(
          key: _formKey,
          child: Container(
            alignment: Alignment.topRight,
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const Text(
                  'Add Category',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 36,
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    Container(
                      height: 250,
                      width: 250,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        color: Colors.grey.shade50,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_isButtonVisible)
                            TextButton(
                              onPressed: () {
                                selectImage();
                              },
                              child: const Text(
                                'Select Image',
                                style: TextStyle(color:Colors.black),
                              ),
                            ),
                          imgUrl.isNotEmpty
                              ? Image.network(
                            imgUrl,
                            fit: BoxFit.cover,
                          )
                              : Container(),
                        ],
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: libelleController,
                          decoration: InputDecoration(
                            hintText: 'Name Category',
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
                                return 'Le libellé est obligatoire';
                              }
                              return null;
                            },
                          ),
                          if (_formKey.currentState?.validate() ?? false)
                            const Text(
                              'Le libellé est obligatoire',
                              style: TextStyle(color: Colors.red),
                            ),
                          SizedBox(height: 15), // Add some space between text field and button
                          Container(
                            width: 200,
                            child: TextButton(
                              child: Text('Add', style: TextStyle(color: Colors.white)),
                              onPressed: () {
                                if (_visible) {
                                  if (file != null) {
                                    if (_formKey.currentState?.validate() ?? false) {
                                      uploadToFirebase();
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Addition successful'),
                                            content: Text('Your category has been successfully added.'),
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
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Error'),
                                            content: Text('Please select an image and fill the label'),
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
                                  }
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Error'),
                                        content: Text('Please select an image and fill the label '),
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
                              style: TextButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 160, 208, 247),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
