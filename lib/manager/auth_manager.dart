import 'package:firebase_auth/firebase_auth.dart';

import '../common/either.dart';

class AuthManager {
  final FirebaseAuth firebaseAuth;

  AuthManager({
    required this.firebaseAuth,
  });

  Stream<bool> get isAuthStream =>
      firebaseAuth.authStateChanges().map((user) => user != null);

  bool get isAuth => firebaseAuth.currentUser != null;

  Future<Either<Exception, void>> signInAnon() async {
    try {
      await firebaseAuth.signInAnonymously();
      return Either.right(null);
    } on Exception catch (e) {
      return Either.left(e);
    }
  }
}
