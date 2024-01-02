import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../platform/src/platform_bottom_sheet.dart';

Future<void> showDrinkedDialog({
  required BuildContext context,
}) async =>
    showPlatformBottomSheet(
      context: context,
      expand: true,
      builder: (context) {
        return const DrinkedDialog();
      },
    );

class DrinkedDialog extends StatelessWidget {
  const DrinkedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Column(
        children: [
          CupertinoNavigationBar(
            leading: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Отменить'),
            ),
            middle: Text('Алкоголь'),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              child: Text('Добавить'),
            ),
          ),
          CupertinoListSection.insetGrouped(
            additionalDividerMargin: 0,
            backgroundColor: Colors.transparent,
            children: [
              CupertinoListTile(
                title: Text('Что пьём?'),
                onTap: () => _selectAlcohol(context: context),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Text('-'),
                ),
              ),
            ],
          ),
          CupertinoListSection.insetGrouped(
            additionalDividerMargin: 0,
            backgroundColor: Colors.transparent,
            children: [
              CupertinoListTile(
                title: Text('Дата'),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Text('10.20.2232'),
                ),
              ),
              CupertinoListTile(
                title: Text('Время'),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Text('18:24'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> _selectAlcohol({
  required BuildContext context,
}) =>
    showPlatformBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 250,
        child: CupertinoPicker(
          itemExtent: 32,
          onSelectedItemChanged: (_) {},
          children: [
            Center(child: Text('Пиво')),
            Center(child: Text('Водка')),
            Center(child: Text('Виски')),
          ],
        ),
      ),
    );
