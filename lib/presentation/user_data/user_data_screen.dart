import 'package:flutter/cupertino.dart' hide CupertinoTextField;
import 'package:flutter/material.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../common/cupertino_text_field.dart';

class UserDataScreen extends StatelessWidget {
  const UserDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('Данные пользователя'),
      ),
      body: ListView(
        physics: const ScrollPhysics(),
        children: [
          CupertinoListSection.insetGrouped(
            backgroundColor: Colors.transparent,
            additionalDividerMargin: 0,
            footer: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DefaultTextStyle(
                style: theme.textTheme.titleSmall!.copyWith(
                  color: theme.hintColor,
                ),
                child: Text(
                    'Ваши данные не обязательны, но помогают нам персонализировать ваш опыт использования. Ваша информация остается конфиденциальной.'),
              ),
            ),
            children: [
              CupertinoTextField(
                title: Text('Вес'),
                onChanged: (str) {},
              ),
              CupertinoTextField(
                title: Text('Рост'),
                onChanged: (str) {},
              ),
              CupertinoTextField(
                title: Text('Возраст'),
                onChanged: (str) {},
              ),
              CupertinoListTile(
                title: Text('Пол'),
                trailing: PullDownButton(
                  itemBuilder: (context) => [
                    PullDownMenuItem(
                      onTap: () {},
                      title: 'Мужичара',
                    ),
                    PullDownMenuItem(
                      onTap: () {},
                      title: 'Девчуля',
                    ),
                  ],
                  buttonBuilder: (context, showMenu) => CupertinoButton(
                    onPressed: showMenu,
                    child: const Text('Мужичара'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
