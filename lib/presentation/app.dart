import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../dependencies.dart';
import 'platform/platform.dart';
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
        onGenerateRoute: (settings) {
          final Widget? page = switch (settings.name) {
            '/welcome' => const WelcomeScreen(),
            '/main' => const Scaffold(),
            _ => null,
          };

          if (page == null) {
            return null;
          }

          return MaterialPageRoute(
            builder: (context) => CupertinoScaffold(
              body: page,
            ),
          );
        },
        builder: (context, child) {
          return PlatformProviderHolder(
            child: child!,
          );
        },
      ),
    );
  }
}
