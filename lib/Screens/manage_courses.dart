import 'package:elearning_admin_pannel/Screens/side_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import '../Services/firebase_services.dart';
import '../courses/AddCourses.dart';
import '../courses/EditCourse.dart';

class ManageCoursesScreen extends StatefulWidget {
  static const String id = "manage_courses_screen";

  @override
  State<ManageCoursesScreen> createState() => _ManageCoursesScreenState();
}

class _ManageCoursesScreenState extends State<ManageCoursesScreen> {
  final CollectionReference courses =
  FirebaseFirestore.instance.collection('courses');
  void deleteCourses(docId) {
    courses.doc(docId).delete();
  }
  void _showCoursesDetails(
      String id, String name, String images, double price, String duration,
      String session, String discount, String description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
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
                      'Price: ',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        '${price.toString()} \Dt  ',
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
                      'Description: ',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        '$description',
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
                      'Duration: ',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        '${duration.toString()} \h',
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
                        '${session.toString()} \lessons',
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
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditCourse(
                      id: id,
                      name: name,
                      image: images,
                      price: price.toString(),
                      description: description,
                      duration: duration,
                      session: session,
                      discount: discount,
                    ),
                  ),
                );
              },
              child: Text('Modifier', style: TextStyle(color: Colors.black),),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 139, 195, 240)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color:Color.fromARGB(255, 139, 195, 240)),
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Fermer", style: TextStyle(color: Colors.black),),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SideBarWidget _sideBar = SideBarWidget();
    TextEditingController searchController = TextEditingController();
    //String selectedCategory = 'Tous les produits';
    FirebaseServices _services = FirebaseServices();

    return StreamBuilder<QuerySnapshot>(
      stream: _services.courses.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        return

          SingleChildScrollView(
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
                    'Courses',
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
                            builder: (context) => AddCourse(),
                          ),
                        );
                      },
                      child: Text('Add Course',
                        style: TextStyle(color: Colors.white),),
                      style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 160, 208, 247)),
                    ),
                  ),
                  const Divider(thickness: 3,),

                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty)
                    SizedBox(
                      height: 430,
                      child: GridView.builder(
                        itemCount: snapshot.data!.docs.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) {
                          DocumentSnapshot document = snapshot.data!.docs[index];

                          // if (selectedCategory == 'Tous les produits' || document['category'] == selectedCategory) {
                          return GestureDetector(
                            onTap:() {
                              _showCoursesDetails(
                                document['id'],
                                document['name'],
                                document['images'],
                                double.parse(document['price']),
                                document['duration'],
                                document['session'],
                                document['review'],
                                document['description'],
                              );
                            },
                            child: Container(
                              width: 270,
                              height: 320,
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.only(bottom: 5,top: 5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(.1),
                                        spreadRadius: 1,
                                        blurRadius: 1,
                                        offset: Offset(1,1)
                                    )
                                  ]
                              ),
                              child: Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 130,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(
                                        (document['images'] as String),
                                        width: MediaQuery.of(context).size.width * 0.2,
                                        height: 10,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),

                                  Positioned(
                                    top: 120,
                                    right: 15,
                                    child:
                                    Container(
                                        padding: EdgeInsets.all(7),
                                        decoration: BoxDecoration(color: Color.fromARGB(255, 223, 132, 126),
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Text(
                                          '${document['price'].toString() } dt',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                    ),
                                  ),

                                  Positioned(
                                    //top:150,
                                      right: 25,
                                      child: IconButton(
                                        onPressed: (){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => EditCourse(
                                              id: document['id'],
                                              name: document['name'],
                                              image: document['images'],
                                              price: document['price'].toString(),
                                              description: document['description'],
                                              duration: document['duration'],
                                              session: document['session'],
                                              discount: document['discount'],
                                            ),),
                                          );
                                        }, icon: Icon(Icons.edit,
                                        color: const Color.fromARGB(255, 223, 132, 126),
                                        size: 15,),)
                                  ),

                                  Positioned(
                                    //top: 150,
                                      right: 3,
                                      child: IconButton(
                                        icon: const Icon(Icons.delete),
                                        iconSize: 15,
                                        color: Color.fromARGB(255, 223, 132, 126),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context){
                                                return AlertDialog(
                                                  title: Text("Confirm Deletion"),
                                                  content: Text("Are you sure you want to delete this course?"),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text("Cancel"),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text("delete",),
                                                      onPressed: () {
                                                        deleteCourses(document.id);
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              }
                                          );
                                        },)

                                  ),

                                  //NAME
                                  Positioned(
                                    top: 130,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          document['name'],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),

                                        ),
                                        SizedBox(height:10),
                                        Row(

                                          children: [
                                            Icon(Icons.play_circle_rounded,size: 12,color: Colors.grey,),
                                            SizedBox(width: 3,),
                                            Text(
                                              '${document['session'].toString() } lessons',

                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),

                                            ),
                                            SizedBox(width: 16,),
                                            Icon(Icons.access_time_rounded,size: 12,color: Colors.grey,),
                                            SizedBox(width: 3,),
                                            Text(
                                              '${document['duration'].toString() } h',

                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),

                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                          /* } else {
                         return Container();
                       }*/
                        },
                      ),
                    ),
                ],
              ),
            ),

          );

      },
    );

  }

}