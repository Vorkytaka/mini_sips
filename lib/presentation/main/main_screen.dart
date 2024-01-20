import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../drinked/drinked_dialog.dart';

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
      body: Center(
        child: CupertinoButton.filled(
          child: Text('123'),
          onPressed: () {},
        ),
      ),
    );
  }
}
