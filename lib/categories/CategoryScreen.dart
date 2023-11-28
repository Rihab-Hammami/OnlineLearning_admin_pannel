import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

import '../Screens/side_bar_widget.dart';
import 'Category_widget.dart';
import 'addCategory.dart';

class CategoryScreen extends StatefulWidget {
  static const String id = 'category-screen';

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    SideBarWidget _sideBar = SideBarWidget();

    return SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AddEditCategorie(),

              SizedBox(height: 30),
              const Text(
                'All categories',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
              ),


              Divider(thickness: 2),
              SizedBox(height: 30),
              CategorieWidget(),
              // Add the rest of your widget tree here
            ],
          ),
        ),
      );

  }
}
