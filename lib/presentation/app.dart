import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../dependencies.dart';
import 'welcome/welcome_screen.dart';

class App extends StatelessWidget {
  final Dependencies dependencies;

  const App({
    super.key,
    required this.dependencies,
  });

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: dependencies,
      updateShouldNotify: (_, __) => false,
      child: MaterialApp(
        initialRoute: dependencies.authManager.isAuth ? '/main' : '/welcome',
        routes: {
          '/welcome': (context) => const WelcomeScreen(),
          '/main': (context) => const Scaffold(),
        },
      ),
    );
  }
}
