import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearning_admin_pannel/courses/CoursesScreen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

import '../Screens/manage_courses.dart';

class EditCourse extends StatefulWidget{
  final String id;
  final String name;
  final String image;
  final String price;
  final String duration;
  final String session;
  final String review;
  final String description;

  EditCourse({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.duration,
    required this.session,
    required this.review,
    required this.description,
  });


  @override
  _EditCourseState createState() => _EditCourseState();
}

class _EditCourseState extends State<EditCourse> {

  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController session = TextEditingController();
  TextEditingController review = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController duration = TextEditingController();
  late TextEditingController _imageController;

  String imageUrl = '';
  Uint8List? _imageBytes;
  GlobalKey<FormState> _key = GlobalKey();
  late DocumentReference _reference;
  @override
  void initState() {
    imageUrl = widget.image;
    name = TextEditingController(text: widget.name);
    price = TextEditingController(text: widget.price.toString());
    description = TextEditingController(text: widget.description);
    _imageController= TextEditingController(text: widget.image) ;
    session = TextEditingController(text: widget.session);
    review = TextEditingController(text: widget.review.toString());
    duration = TextEditingController(text: widget.duration.toString()) ;
    _reference = FirebaseFirestore.instance.collection('courses').doc(widget.id);

    super.initState();
  }
  void _updateImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    print('FilePickerResult: $result');
    if (result != null && result.files.isNotEmpty) {
      Uint8List bytes = result.files.single.bytes!;
      String imageURL = await uploadImageToFirebaseStorage(bytes);
      setState(() {
        imageUrl = imageURL;
      });
    }
  }



  Future<String> uploadImageToFirebaseStorage(Uint8List bytes) async {
    FirebaseStorage fs = FirebaseStorage.instance;
    int date = DateTime.now().millisecondsSinceEpoch;
    final reference = await fs.ref().child('courses/$date.png');

    // Explicitly set the content type to image/png
    SettableMetadata metadata = SettableMetadata(contentType: 'image/png');
    final uploadTask = reference.putData(bytes, metadata);

    final snapshot = await uploadTask;
    String imageURL = await snapshot.ref.getDownloadURL();
    return imageURL;
  }



  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor:Color.fromARGB(255, 216, 189, 154),
          title: const Text('Epi Go Dashboard',style: TextStyle(color:Colors.white,),),
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 80.0),

            child: Form(
                key: _key,
                child: Column(
                  children: [
                    InkWell(
                      onTap: _updateImage,
                      child: Container(
                        height: 350,
                        width: 350,
                        decoration: BoxDecoration(
                          border: Border.all(),
                        ),
                        child: SizedBox(
                          height: 100,
                          child: imageUrl.isEmpty
                              ? Center(child: Text('Ajouter image'))
                              : Builder(
                            builder: (context) {
                              try {
                                return Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                );
                              } catch (e) {
                                print('Error loading image: $e');
                                return Center(child: Text('Error loading image'));
                              }
                            },
                          ),
                        ),

                      ),
                    ),
                    SizedBox(height: 10,),


                    Container(

                      width: 600,
                      child:const Text(
                        'Titre',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,fontWeight: FontWeight.bold
                        ),
                      ),
                    ),



                    //SizedBox(height: 8),
                    Container(

                      width: 600,
                      child: TextFormField(
                        controller:   name,
                        decoration:
                        InputDecoration(hintText: 'Titre'),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return '***champ obligatoire';
                          }

                          return null;
                        },
                      ),
                    ),



                    SizedBox(height: 8),
                    Container(

                      width: 600,
                      child:const Text(
                        'Catégorie',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,fontWeight: FontWeight.bold
                        ),
                      ),
                    ),

                    SizedBox(height: 8),
                    Container(

                      width: 600,
                      child:const Text(
                        'Description',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Container(
                      width: 600,
                      //height: 800,
                      child: TextFormField(
                        controller: description,
                        decoration: InputDecoration(
                          hintText: 'Description',
                        ),
                        maxLines: 3, // Set maxLines to 2 for multiline input
                        textInputAction: TextInputAction.newline, // Provide newline action
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return '***champ obligatoire';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(

                      width: 600,
                      child:const Text(
                        'Prix',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Container(
                      width: 600,

                      child: TextFormField(
                        controller:  price,
                        decoration: InputDecoration(
                          hintText: 'Prix',
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return '***champ obligatoire';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 8),

                    Container(

                      width: 600,
                      child:const Text(
                        'duration',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Container(
                      width: 600,
                      child: TextFormField(
                        controller: duration,
                        decoration: InputDecoration(hintText: 'Remise (%)'),
                        keyboardType: TextInputType.number,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return '***champ obligatoire';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 8),

                    Container(

                      width: 600,
                      child:const Text(
                        'session',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Container(
                      width: 600,
                      child: TextFormField(
                        controller: session,
                        decoration: InputDecoration(hintText: 'Remise (%)'),
                        keyboardType: TextInputType.number,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return '***champ obligatoire';
                          }
                          return null;
                        },
                      ),
                    ),


                    SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () async {
                        String Name = name.text;
                        String Price = price.text;
                        String Description = description.text;
                        //String image = _imageController.text;
                        String Session = session.text;
                        String Duration = duration.text;


                        // Create the Map of data
                        Map<String, dynamic> dataToUpdate = {
                          'name': Name,
                          'description': Description,
                          'imageUrl': imageUrl,
                          'price': Price,
                          'session': Session,
                          'Duration': Duration,
                        };
                        //if (Key.currentState?.validate() ?? false){
                        _reference.update(dataToUpdate);
                        // }
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Produit modifié avec Succés!'),
                              backgroundColor: Colors.green,

                            )
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => ManageCoursesScreen()),
                        );
                      },
                      child: Text('Modifier'),
                      style: ElevatedButton.styleFrom(),
                    ),
                  ],
                )

            )
        )
    );
  }
}