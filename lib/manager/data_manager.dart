import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../domain/alcohol.dart';

class DataManager {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  DataManager({
    required this.auth,
    required this.firestore,
  });

  Future<void> addDrink(Alcohol alcohol) async {
    final userUid = auth.currentUser?.uid;

    if (userUid == null) {
      return;
    }

    final userDocument = firestore.collection('users').doc(userUid);
    final userAlcoholCollection = userDocument.collection('alcohol');

    await userAlcoholCollection.add(alcohol.toJson);
  }
}
