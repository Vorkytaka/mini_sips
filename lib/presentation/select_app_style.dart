import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectAppStyleScreen extends StatelessWidget {
  const SelectAppStyleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('Выберите хрень'),
      ),
    );
  }
}