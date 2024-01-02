import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'dependencies.dart';
import 'firebase_options.dart';
import 'presentation/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final firebase = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final Dependencies dependencies = DependenciesImpl(firebase: firebase);

  runApp(App(dependencies: dependencies));
}
