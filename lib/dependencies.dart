import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'manager/auth_manager.dart';

abstract class Dependencies {
  FirebaseApp get firebase;

  FirebaseAuth get firebaseAuth;

  AuthManager get authManager;
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
  late final AuthManager authManager = AuthManager(firebaseAuth: firebaseAuth);
}
