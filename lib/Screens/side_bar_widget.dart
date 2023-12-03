// ignore: file_names

import 'package:elearning_admin_pannel/Screens/dashboard_screen.dart';
import 'package:elearning_admin_pannel/Screens/home_screen.dart';
import 'package:elearning_admin_pannel/Screens/manage_courses.dart';
import 'package:elearning_admin_pannel/Screens/manage_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

import '../categories/CategoryScreen.dart';

class SideBarWidget{
  
   sideBarMenus(context, selectedRoute){
    return SideBar(
        items: const [
          AdminMenuItem(
            title: 'Dashboard',
            route: DashboardScreen.id,
            icon: Icons.dashboard,
          ),
          AdminMenuItem(
            title: 'Manage Course',
            route: ManageCoursesScreen.id,
            icon: Icons.book_online_rounded,
          ),
          AdminMenuItem(
            title: 'Manage Categorie',
            route: CategoryScreen.id,
            icon: Icons.category,
          ),
          AdminMenuItem(
            title: 'Manage Lesson',
            route: ManageItemsScreen.id,
            icon: Icons.play_lesson,
          ),
          AdminMenuItem(
            title: 'Manage Exercice',
            route: ManageItemsScreen.id,
            icon: Icons.play_lesson,
          ),
          AdminMenuItem(
            title: 'Manage items',
            route: ManageItemsScreen.id,
            icon: Icons.pages_rounded,
          ),
          
          
        ],
          selectedRoute: selectedRoute,
        onSelected: (item) {
          if (item.route != null) {
            Navigator.of(context).pushNamed(item.route!);
          }
          }
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
      );
   }
   
}