import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearning_admin_pannel/Screens/side_bar_widget.dart';
import 'package:elearning_admin_pannel/lessons/LessonsScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class EditLesson extends StatefulWidget {
  final String id;
  final String name;
  final String duration;
  String fileUrl;
  final String images;
  final String teacherId;

  EditLesson({
    required this.id,
    required this.name,
    required this.duration,
    required this.fileUrl,
    required this.images,
    required this.teacherId,
  });

  @override
  _EditLessonState createState() => _EditLessonState();
}

class _EditLessonState extends State<EditLesson> {
  TextEditingController nameController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  late FirebaseFirestore firestore;
  late CollectionReference lessonsCollection;
  late String imageUrl;
  late String selectedFilePath;
  String selectedCourse="0";

  @override
  void initState() {
    super.initState();
    nameController.text = widget.name;
    durationController.text = widget.duration;
    imageUrl = widget.images;
    selectedFilePath = widget.fileUrl;
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);

    if (pickedImage != null) {
      setState(() {
        imageUrl = pickedImage.path;
      });
    }
  }

  Future<void> _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        selectedFilePath = result.files.single.path ?? '';
      });
    }
  }

  void _updateImage() {
    
  }

void _updateLessonData() async {
  String newName = nameController.text;
  String newDuration = durationController.text;
  String newFileUrl = selectedFilePath; // Get the new file URL
  String newImageUrl = imageUrl; // Get the new image URL

  try {
    await FirebaseFirestore.instance
        .collection('courses')
        .doc(selectedCourse)
        .collection('lessons')
        .doc(widget.id)
        .update({
          'name': newName,
          'duration': newDuration,
          'fileUrl': newFileUrl,
          'images': newImageUrl, // Include the updated image URL
          // Add other fields to update in the document
        });

    print('Lesson data updated successfully!');
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return LessonsScreen();
        },
      ),
    );
  } catch (error) {
    print('Failed to update lesson data: $error');
    // Handle the error as needed
  }
}



  @override
  Widget build(BuildContext context) {
  SideBarWidget _sideBar = SideBarWidget();
    return AdminScaffold(
     appBar: AppBar(
        title: Center(child: Text("Edit lesson")),
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
          ),
        ),
      ),
       sideBar: _sideBar.sideBarMenus(context,LessonsScreen.id),
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
            child: Form(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      _pickImage(ImageSource.gallery);
                    },
                    child: Container(
                      height: 350,
                      width: 350,
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: SizedBox(
                        height: 100,
                        child: imageUrl.isEmpty
                            ? Center(child: Text('Add Image'))
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
                  ElevatedButton(
                    onPressed: () {
                      _updateImage();
                    },
                    child: Text('Update Image'),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Lesson Name'),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: durationController,
                    decoration: InputDecoration(labelText: 'Lesson Duration'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _selectFile();
                    },
                    child: Text('Select File'),
                  ),
                  SizedBox(height: 20),
                  selectedFilePath.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Selected File: $selectedFilePath'),
                          ],
                        )
                      : Container(),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _updateLessonData();
                    },
                     style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 98, 183, 252)),
                        ),
                    child: Text('Update Lesson Data',style: TextStyle(color:Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
