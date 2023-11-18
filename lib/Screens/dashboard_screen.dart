import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  static const String id = "dashboard_screen";

  Widget analyticWidget({required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Container(
        width: 200,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.blue,
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
          analyticWidget(title:"Total users",value:"0"),
          analyticWidget(title: "Total categories",value: "0"),
           analyticWidget(title: "Total courses",value: "0"),
           analyticWidget(title: "Total items",value: "0"),
           analyticWidget(title: "",value: ""),

        ],
      ),
      
    ],
    
);
  }
}
