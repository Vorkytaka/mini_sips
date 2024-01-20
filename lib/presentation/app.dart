import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../dependencies.dart';
import 'check_app_style.dart';
import 'main/main_screen.dart';
import 'platform/platform.dart';
import 'select_app_style.dart';
import 'ui_dependencies.dart';
import 'welcome/welcome_screen.dart';

class App extends StatelessWidget {
  final Dependencies dependencies;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  App({
    required this.dependencies,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: dependencies,
      updateShouldNotify: (_, __) => false,
      child: UiDependenciesWidget(
        dependencies: dependencies,
        navigatorKey: navigatorKey,
        child: _App(
          dependencies: dependencies,
          navigatorKey: navigatorKey,
        ),
      ),
    );
  }
}

class _App extends StatelessWidget {
  final Dependencies dependencies;
  final GlobalKey<NavigatorState> navigatorKey;

  const _App({
    required this.dependencies,
    required this.navigatorKey,
  });

  @override
  Widget build(BuildContext context) {
    final platform = PlatformProvider.of(context);

    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xfff2f1f6),
        platform: platform,
      ),
      initialRoute:
          dependencies.authManager.isAuth ? '/check_app_style' : '/welcome',
      onGenerateRoute: (settings) {
        final Widget? page = switch (settings.name) {
          '/welcome' => const WelcomeScreen(),
          '/main' => const MainScreen(),
          '/check_app_style' => const CheckAppStyleScreen(),
          '/select_app_style' => const SelectAppStyleScreen(),
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
    );
  }
}
