import 'package:elearning_admin_pannel/Quiz/create_quiz.dart';
import 'package:elearning_admin_pannel/Screens/GoogleFormWebView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../Quiz/quizScreen.dart';
class ManageItemsScreen extends StatelessWidget {
  static const String id="manage_items_screen";

  @override
  Widget build(BuildContext context) {
    return Center(child:
    Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizScreen(),
            ),
          );
        },
        child: Text(
          'Add Quiz',
          style: TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 160, 208, 247),
        ),
      ),
    ),

    );
  }
}
