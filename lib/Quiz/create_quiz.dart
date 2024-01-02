import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

import '../Services/database.dart';
import '../widget.dart';
import 'AddQuestion.dart';

class CreateQuiz extends StatefulWidget {


  @override
  _CreateQuizState createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  final currentUser = FirebaseAuth.instance.currentUser;
  String selectedCourseId = "0"; // Add this variable to store the selected course ID



  DatabaseService databaseService = DatabaseService(uid: '');


  final _formKey = GlobalKey<FormState>();

  late String quizImgUrl, quizTitle, quizDesc,quizId;

  bool isLoading = false;

  bool _isCategorieSelected = false;



  createQuiz(){
    String? uid = currentUser?.uid;
    quizId = randomAlphaNumeric(16);
    if(_formKey.currentState!.validate()){

      setState(() {
        isLoading = true;
      });

      Map<String, String> quizData = {
        "quizImgUrl" : quizImgUrl,
        "quizTitle" : quizTitle,
        "quizDesc" : quizDesc,
        "quizId" : quizId,
        "userId":  uid ?? "", // Add the user ID to the quiz data
        "courseId": selectedCourseId, // Add the selected course ID to the quiz data


      };

      databaseService.addQuizData(quizData, quizId).then((value){
        setState(() {
          isLoading = false;
        });
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) =>  AddQuestion(quizId)
        ));
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black54,
        ),
        title: AppLogo(),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        //brightness: Brightness.li,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              TextFormField(
                validator: (val) => val!.isEmpty ? "Enter Quiz Image Url" : null,
                decoration: InputDecoration(
                    hintText: "Quiz Image Url (Optional)"
                ),
                onChanged: (val){
                  quizImgUrl = val;
                },
              ),
              SizedBox(height: 5,),
              TextFormField(
                validator: (val) => val!.isEmpty ? "Enter Quiz Title" : null,
                decoration: InputDecoration(
                    hintText: "Quiz Title"
                ),
                onChanged: (val){
                  quizTitle = val;
                },
              ),
              SizedBox(height: 5,),
              TextFormField(
                validator: (val) => val!.isEmpty ? "Enter Quiz Description" : null,
                decoration: InputDecoration(
                    hintText: "Quiz Description"
                ),
                onChanged: (val){
                  quizDesc = val;
                },
              ),
              // Add a DropdownButtonFormField or any other way to select the course ID
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
                            selectedCourseId = categorieValue;
                            _isCategorieSelected = true;
                          });
                        },
                        value: selectedCourseId,
                        isExpanded: false,
                        hint: Text('Sélectionner une catégorie'),
                      );
                    },
                  ),
                ],
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  createQuiz();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(
                      horizontal: 24, vertical: 20),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30)),
                  child: Text(
                    "Create Quiz",
                    style: TextStyle(
                        fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 60,
              ),
            ],)
          ,),
      ),
    );
  }
}