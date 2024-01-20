import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../common/either.dart';

class AuthManager {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthManager({
    required this.firebaseAuth,
    required this.firestore,
  });

  Stream<bool> get isAuthStream =>
      firebaseAuth.authStateChanges().map((user) => user != null);

  bool get isAuth => firebaseAuth.currentUser != null;

  Future<bool> get isAppStyleSelected async {
    final userUid = firebaseAuth.currentUser?.uid;

    if (userUid == null) {
      return false;
    }

    final userCollection = firestore.collection('users').doc(userUid);
    final userDoc = await userCollection.get();
    return userDoc.data()?['app_style'] != null;
  }

  Future<Either<Exception, void>> signInAnon() async {
    try {
      await firebaseAuth.signInAnonymously();
      return Either.right(null);
    } on Exception catch (e) {
      return Either.left(e);
    }
  }
}
