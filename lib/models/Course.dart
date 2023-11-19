import 'package:cloud_firestore/cloud_firestore.dart';

class Course {

  late String id;
  late final String name;
  late final String image;
  late final String price;
  late final String duration;
  late final String session;
  late final String review;
  late final String is_favorited;
  late final String description;


Course({
  required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.duration,
    required this.session,
    required this.review,
    required this.is_favorited,
    required this.description,

});
  Course.fromDocumentSnapshot({required DocumentSnapshot snapshot}) {
    id = snapshot.id;
    name = snapshot['name'];
    image = snapshot['image'];
    price = snapshot['price'];
    duration = snapshot['duration'];
    session = snapshot['session'];
    review = snapshot['review'];
    is_favorited = snapshot['is_favorited'];
    description = snapshot['description'];

  }
  Course.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    image = map['image'];
    price = map['price'];
    duration = map['duration'];
    //unit = map.containsKey('unit') ? map['unit'] ?? 'DefaultUnit' : 'DefaultUnit';
    session = map['session'];
    review = map['review'];
    is_favorited = map['is_favorited'];
    description = map['description'];

  }
  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'image': image,
    'price': price,
    'duration': duration,
    'session': session,
    'description': description,
    'review': review,
    'is_favorited': is_favorited,
    'description': description,


  };
}