import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;

  User({this.uid});
}

class UserData {
  final String uid;
  final String name;
  final String food;
  final int count;

  UserData({this.uid, this.name, this.food, this.count});
}

class Post {
  final String id;
  final String name;
  final String foodcount;
  final String address;
  var createdAt;

  // https://dart.dev/guides/language/language-tour#constructors
  Post({this.id,this.name, this.foodcount, this.address});

  // https://codelabs.developers.google.com/codelabs/flutter-firebase/index.html#4
  // 1. Using "Named constructors"
  // 2. Using "Initializer list"
  Post.fromFirestore(DocumentSnapshot document)
      : id = document.documentID,
        name = document['name'],
        foodcount = document['foodcount'],
        address = document['address'];
        
}
