import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CrudMedthods {
  static String uid;

  bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser() != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> addData(carData) async {
    if (isLoggedIn()) {
      Firestore.instance.collection('users').add(carData).catchError((e) {
        print(e);
      });
      //Using Transactions
      // Firestore.instance.runTransaction((Transaction crudTransaction) async {
      //   CollectionReference reference =
      //       await Firestore.instance.collection('users');

      //   reference.add(carData);
      // });
    } else {
      print('You need to be logged in');
    }
  }

  getData() async {
    return  Firestore.instance.collection('users').snapshots();
  }

  updateData(selectedDoc, newValues) {
    Firestore.instance
        .collection('users')
        .document(selectedDoc)
        .updateData(newValues)
        .catchError((e) {
      print(e);
    });
  }

  deleteData(user) async {
    final FirebaseAuth _auth =
                                              FirebaseAuth.instance;
                                          FirebaseUser user =
                                              await _auth.currentUser();
    Firestore.instance
        .collection('users')
        .document(user.uid).collection('posts').document()
        .delete()
        .catchError((e) {
      print(e);
    });
  }
}
