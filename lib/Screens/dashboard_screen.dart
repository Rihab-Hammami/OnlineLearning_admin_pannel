import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elearning_admin_pannel/Screens/Services/firebase_services.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  static const String id = "dashboard_screen";
  FirebaseServices _services =FirebaseServices();

  Widget analyticWidget({required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child:Container(
  width: 200,
  height: 100,
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Color(0xFF00B4DB), // #00416A color
        Color(0xFFC9D6FF), // #E4E5E6 color
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    border: Border.all(color: Colors.blueGrey),
    borderRadius: BorderRadius.circular(10),
  ),
  child: Padding(
    padding: const EdgeInsets.all(18.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value,
              style: TextStyle(color: Colors.white),
            ),
            Icon(Icons.show_chart, color: Colors.white),
          ],
        )
      ],
    ),
  ),
),

    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
   crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Wrap(
        spacing: 20,
        runSpacing: 20,
        children: [
          StreamBuilder<QuerySnapshot>(
      stream: _services.users.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(width: 200,
                  height: 100,
                  decoration: BoxDecoration(
            color: Colors.blue,
            border: Border.all(color: Colors.blueGrey),
            borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(child: CircularProgressIndicator(color: Colors.white,)),
                  ),
          );
        }
        if(snapshot.hasData){
             return analyticWidget(title:"Total users",value:snapshot.data!.size.toString());
        }
        return SizedBox();

       
      },
    ),

          analyticWidget(title:"Total users",value:"0"),
          analyticWidget(title: "Total categories",value: "0"),
           analyticWidget(title: "Total courses",value: "0"),
           analyticWidget(title: "Total items",value: "0"),
           

        ],
      ),
      
    ],
    
);
  }
}
