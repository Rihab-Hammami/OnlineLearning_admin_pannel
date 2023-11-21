import 'package:elearning_admin_pannel/Screens/dashboard_screen.dart';
import 'package:elearning_admin_pannel/Screens/manage_courses.dart';
import 'package:elearning_admin_pannel/Screens/manage_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
class Home_screen extends StatefulWidget {
  static const String id="home_screen";

  @override
  State<Home_screen> createState() => _Home_screenState();
}

class _Home_screenState extends State<Home_screen> {

Widget _selectedScreen=DashboardScreen();
currentScreen(item){
  switch(item.route){
    case DashboardScreen.id:
    setState(() {
      _selectedScreen=DashboardScreen();
    });
    break;
     case ManageCoursesScreen.id:
    setState(() {
      _selectedScreen=ManageCoursesScreen();
    });
    break;
     case ManageItemsScreen.id:
    setState(() {
      _selectedScreen=ManageItemsScreen();
    });
    break;

  }
}

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        
         flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF00B4DB), // #00416A color
                Color(0xFFC9D6FF), // #E4E5E6 color
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Center(
        child: const Text('Online Learning App Dashboard',
        style: TextStyle(color:Colors.white))),
      ),
      sideBar: SideBar(
        items: const [
          AdminMenuItem(
            title: 'Dashboard',
            route: DashboardScreen.id,
            icon: Icons.dashboard,
          ),
          AdminMenuItem(
            title: 'Manage Course',
            route: ManageCoursesScreen.id,
            icon: Icons.dashboard,
          ),
          AdminMenuItem(
            title: 'Manage items',
            route: ManageItemsScreen.id,
            icon: Icons.pages_rounded,
          ),
          
          
        ],
        selectedRoute: Home_screen.id,
        onSelected: (item) {
          currentScreen(item);
         // if (item.route != null) {
           // Navigator.of(context).pushNamed(item.route!);
          //}
        },
       /* header: Container(
          height: 50,
          width: double.infinity,
          color: const Color(0xff444444),
          child: const Center(
            child: Text(
              'header',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        footer: Container(
          height: 50,
          width: double.infinity,
          color: const Color(0xff444444),
          child: const Center(
            child: Text(
              'footer',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),*/
      ),
      body: SingleChildScrollView(
        child: _selectedScreen,
      ),
    );
  }
}