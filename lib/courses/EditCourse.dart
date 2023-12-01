import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearning_admin_pannel/Screens/side_bar_widget.dart';
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
  final String discount;
  final String category;
  final String description;

  EditCourse({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.duration,
    required this.session,
    required this.discount,
    required this.category,
    required this.description,
  });


  @override
  _EditCourseState createState() => _EditCourseState();
}

class _EditCourseState extends State<EditCourse> {

  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController session = TextEditingController();
  TextEditingController discount = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController duration = TextEditingController();
  late TextEditingController _imageController;
  String  selectedCategorie="";
  String imageUrl = '';
  Uint8List? _imageBytes;
  GlobalKey<FormState> _key = GlobalKey();
  late DocumentReference _reference;
  @override
  void initState() {
    selectedCategorie= widget.category;
    imageUrl = widget.image;
    name = TextEditingController(text: widget.name);
    price = TextEditingController(text: widget.price.toString());
    description = TextEditingController(text: widget.description);
    _imageController= TextEditingController(text: widget.image) ;
    session = TextEditingController(text: widget.session);
    discount = TextEditingController(text: widget.discount.toString());
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
    final reference = await fs.ref().child('images/$date.png');

    // Explicitly set the content type to image/png
    SettableMetadata metadata = SettableMetadata(contentType: 'image/png');
    final uploadTask = reference.putData(bytes, metadata);

    final snapshot = await uploadTask;
    String imageURL = await snapshot.ref.getDownloadURL();
    return imageURL;
  }



  @override
  Widget build(BuildContext context) {
    SideBarWidget _sideBar = SideBarWidget();
    return AdminScaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor:Colors.blueAccent,
          title: Center(child: const Text('Edit Course',style: TextStyle(color:Colors.white,),)),
        ),
        sideBar: _sideBar.sideBarMenus(context, ManageCoursesScreen.id),
        body: Center(
          child: Container(
            width: 700,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),

            child: SingleChildScrollView(
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

                        TextFormField(
                          controller: name,
                          decoration: InputDecoration(
                            hintText: 'Title',
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

                        SizedBox(
                            height: 8),
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

                        ),
                        SizedBox(height: 8),
                        Container(

                          width: 600,
                          child:const Text(
                            'Price',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: price,
                          decoration: InputDecoration(
                            hintText: 'price',
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
                         SizedBox(height: 8),
                        Container(

                          width: 600,
                          child:const Text(
                            'Discount',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: discount,
                          decoration: InputDecoration(
                            hintText: 'Discount',
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
                        TextFormField(
                          controller: duration,
                          decoration: InputDecoration(
                            hintText: 'duration',
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
                        Container(
                          width: 600,
                          child: StreamBuilder<QuerySnapshot>(
                            //stream: FirebaseFirestore.instance.collection('categories').snapshots()
                              stream: FirebaseFirestore.instance.collection('categories').snapshots(),
                              builder: (context, snapshot) {
                                List<DropdownMenuItem<String>> categorieItems = [];
                                if (!snapshot.hasData) {
                                  return const CircularProgressIndicator();
                                } else {
                                  final categories = snapshot.data?.docs.reversed.toList();
                                  categorieItems.add(
                                    const DropdownMenuItem(
                                      value: "0",
                                      child: Text('Categorie sélectionnée'),
                                    ),
                                  );
                                  for (var category in categories!) {
                                    categorieItems.add(DropdownMenuItem(
                                      value: category["libelle"],
                                      child: Text(
                                        category['libelle'],
                                      ),
                                    ));
                                  }
                                }
                                return DropdownButton(
                                  items: categorieItems,
                                  onChanged: (categorieValue) {
                                    setState(() {
                                      selectedCategorie = categorieValue as String;
                                    });
                                    print(categorieValue);
                                  },
                                  value: selectedCategorie,
                                  isExpanded: false,
                                );
                              }
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
                        ),


                        SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () async {
                            String Name = name.text;
                            String Price = price.text;
                            String Discount = discount.text;

                            String Description = description.text;
                            //String image = _imageController.text;
                            String Session = session.text;
                            String Duration = duration.text;
                            String category = selectedCategorie;

                            // Create the Map of data
                            Map<String, dynamic> dataToUpdate = {
                              'name': Name,
                              'description': Description,
                              'imageUrl': imageUrl,
                              'price': Price,
                              'discount': Discount,
                              'session': Session,
                              'duration': Duration,
                              'category': category,
                            };
                            //if (Key.currentState?.validate() ?? false){
                            _reference.update(dataToUpdate);
                            // }
                           
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ManageCoursesScreen();
                                },
                              ),
                            );
                            /* Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => ManageCoursesScreen()),
                            );*/
                          },
                          child: Text('Modifier'),
                          style: ElevatedButton.styleFrom(),
                        ),
                      ],
                    )

                )
            ),
          ),
        )
    );
  }
}