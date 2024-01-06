import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'manager/auth_manager.dart';
import 'manager/data_manager.dart';

abstract class Dependencies {
  FirebaseApp get firebase;

  FirebaseAuth get firebaseAuth;

  FirebaseFirestore get firebaseFirestore;

  AuthManager get authManager;

  DataManager get dataManager;
}

class DependenciesImpl implements Dependencies {
  @override
  final FirebaseApp firebase;

  DependenciesImpl({
    required this.firebase,
  });

  @override
  FirebaseAuth get firebaseAuth => FirebaseAuth.instanceFor(app: firebase);

  @override
  FirebaseFirestore get firebaseFirestore =>
      FirebaseFirestore.instanceFor(app: firebase);

  @override
  late final AuthManager authManager = AuthManager(firebaseAuth: firebaseAuth);

  @override
  late final DataManager dataManager = DataManager(
    auth: firebaseAuth,
    firestore: firebaseFirestore,
  );
}
