import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearning_admin_pannel/courses/AddCourses.dart';

import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

import '../Services/firebase_services.dart';
import 'EditCourse.dart';

class CoursesScreen extends StatefulWidget {
  static const String id = 'Coursescreen';


  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
double width = 0;
late GestureTapCallback onTap = () {
    // Add your custom logic here
  };
  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();
    TextEditingController searchController = TextEditingController();
    String selectedCategory = 'Tous les produits';


    void _showCoursesDetails(
        String id, String name,
        String images, double price, String duration,
        String session, String review, String description) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Image.network(
                    images,
                    width: 400,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),

                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'price: ',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5), // Ajustez la largeur selon vos préférences
                    Expanded(
                      child: Text(
                        '$price',
                        style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description: ',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        '$description',
                        style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'review: ',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5), // Ajustez la largeur selon vos préférences
                    Expanded(
                      child: Text(
                        '$review ',
                        style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'duration: ',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        '$duration',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'session : ',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        '$session',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddCourse(



                      ),
                    ),
                  );
                },
                child: Text('Modifier',style: TextStyle(color: Colors.black),),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue), // Couleur de fond
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // Rayon de la bordure
                      side: BorderSide(color:Colors.blue), // Couleur et épaisseur de la bordure
                    ),
                  ),
                ),
              ),
              TextButton( onPressed: () {
                Navigator.of(context).pop();
              }, child: Text("Fermer",style: TextStyle(color:Colors.black),),),
            ],
          );
        },
      );
    }

    return StreamBuilder<QuerySnapshot>(

        stream: _services.courses.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Quelque chose s'est mal passé");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return AdminScaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Color.fromARGB(255, 216, 189, 154),
                title: const Text('Epi Go Dashboard',style: TextStyle(color:Colors.white,),),

              ),



              body: SingleChildScrollView(
                  child: Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Produits',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 36,
                            ),
                          ),
                          SizedBox(height: 10),
                          SizedBox(height: 30,),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AddCourse(),
                                ),
                              );
                            },
                              child: Text('Ajouter Produit',style: TextStyle(color: Colors.black),),
                              style: ElevatedButton.styleFrom(),

                            ),
                          ),

                          const Divider(thickness: 3,),

                          SizedBox(
                            //width: 400,
                            height: 430,
                            child:GridView.builder(
                              itemCount: snapshot.data!.docs.length,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5,
                                childAspectRatio: 1,
                              ),
                              itemBuilder: (context, index) {
                                DocumentSnapshot document = snapshot.data!.docs[index];

                                // Ajoutez une condition pour filtrer par catégorie
                                if (selectedCategory == 'Tous les produits' || document['category'] == selectedCategory) {
                                  return Card(
                                    elevation: 10,
                                    child: Container(
                                      width: 100,
                                      height: 150,
                                      child: InkWell(
                                        onTap: () {
                                          _showCoursesDetails(
                                            document['id'],
                                            document['name'],
                                            document['images'],
                                            document['price'],
                                              document['review'],
                                            document['description'],
                                            document['duration'],
                                            document['session']
                                          );
                                        },
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                width: width, // Set the desired width for each item
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(20),
                                                  color: Colors.grey[200],

                                                ),
                                                child: GestureDetector(
                                                  onTap: onTap,
                                                  child: Image.network(
                                                    (document['images'] as String),
                                                    width: MediaQuery.of(context).size.width * 0.2,
                                                    height: 100,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  
                                                ),
                                                
                                                
                                              ),
                                              
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                document['name'],
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                '${document['price'].toString() }',
                                                style:const  TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),

                                            ),
                                            const SizedBox(height: 4),


                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return Container(); // Retourne un conteneur vide si la catégorie ne correspond pas
                                }
                              },
                            ),

                          )
                          //CategorieWidget(),
                        ],
                      )
                  )
              )
          );
        });

  }
Widget _buildPrice() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(20),
        
      ),
      child: Text(
        'price',
   //'${document['price'].toString() }',
      style:const  TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,    
      ),
    );
  }
}