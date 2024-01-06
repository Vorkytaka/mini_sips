import 'package:flutter/material.dart';

import '../drinked/drinked_dialog.dart';
import '../home/home_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDrinkedDialog(context: context);
        },
        child: const Icon(Icons.add),
      ),
      body: const HomeScreen(),
    );
  }
}
