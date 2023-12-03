import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add Exercise Link:',
            style: TextStyle(fontSize: 18),
          ),
          TextField(
            controller: _formLinkController,
            decoration: InputDecoration(labelText: 'Google Form Link'),
          ),
          Text(
            'name of Exercise :',
            style: TextStyle(fontSize: 18),
          ),
          TextField(
            controller: _name,
            decoration: InputDecoration(labelText: 'Exercice Name'),
          ),
          SizedBox(height: 16),
          Text(
            'Select Course:',
            style: TextStyle(fontSize: 18),
          ),
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
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _addExerciseLink,
            child: Text('Add Exercise Link'),
          ),
        ],
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
      'name':namee,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Optionally, you can show a success message or clear the form
  }
}

