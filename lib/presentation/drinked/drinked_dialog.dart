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

class DrinkedDialog extends StatefulWidget {
  const DrinkedDialog({super.key});

  @override
  State<DrinkedDialog> createState() => _DrinkedDialogState();
}

class _DrinkedDialogState extends State<DrinkedDialog> {
  bool _showDetails = false;
  bool _showAlcoPicker = false;
  bool _showDateTimePicker = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.viewPaddingOf(context);

    return Material(
      type: MaterialType.transparency,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CupertinoNavigationBar(
            leading: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Отменить'),
            ),
            middle: Text('Алкоголь'),
          ),
          CupertinoListSection.insetGrouped(
            additionalDividerMargin: 0,
            backgroundColor: Colors.transparent,
            children: [
              CupertinoListTileWithBottom(
                title: Text('Что пьём?'),
                onTap: () => setState(() {
                  _showAlcoPicker = !_showAlcoPicker;
                }),
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
                bottom: _showAlcoPicker
                    ? SizedBox(
                        height: 216,
                        child: CupertinoPicker(
                          itemExtent: 32,
                          onSelectedItemChanged: (_) {},
                          children: [
                            Center(child: Text('Пиво')),
                            Center(child: Text('Водка')),
                            Center(child: Text('Виски')),
                          ],
                        ),
                      )
                    : null,
              ),
              CupertinoListTileWithBottom(
                title: Text('Когда'),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Text('Сейчас'),
                ),
                onTap: () => setState(() {
                  _showDateTimePicker = !_showDateTimePicker;
                }),
                bottom: _showDateTimePicker
                    ? SizedBox(
                        height: 216,
                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.dateAndTime,
                          maximumDate:
                              DateTime.now().add(const Duration(minutes: 1)),
                          onDateTimeChanged: (_) {},
                        ),
                      )
                    : null,
              ),
            ],
          ),
          CupertinoListSection.insetGrouped(
            additionalDividerMargin: 0,
            backgroundColor: Colors.transparent,
            children: [
              CupertinoListTile(
                onTap: () => setState(() {
                  _showDetails = !_showDetails;
                }),
                title: Text('Подробнее'),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                ),
              )
            ],
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: kThemeAnimationDuration,
              child: _showDetails
                  ? CupertinoListSection.insetGrouped(
                      additionalDividerMargin: 0,
                      backgroundColor: Colors.transparent,
                      children: [
                        CupertinoListTile(
                          title: Text('Подробнее'),
                        )
                      ],
                    )
                  : const SizedBox(),
            ),
          ),
          Padding(
            padding:
                const EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 10.0),
            child: CupertinoButton.filled(
              child: Text('Добавить'),
              onPressed: () {},
            ),
          ),
          SizedBox(height: mediaQuery.bottom),
        ],
      ),
    );
  }
}

class CupertinoListTileWithBottom extends StatelessWidget {
  final Widget title;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Widget? bottom;

  const CupertinoListTileWithBottom({
    super.key,
    required this.title,
    this.onTap,
    this.trailing,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CupertinoListTile(
          title: title,
          onTap: onTap,
          trailing: trailing,
        ),
        AnimatedSwitcher(
          duration: kThemeAnimationDuration,
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          transitionBuilder: (child, anim) => SizeTransition(
            sizeFactor: anim,
            axis: Axis.vertical,
            axisAlignment: -1,
            child: child,
          ),
          child: bottom ?? const SizedBox.shrink(key: ValueKey(-1994)),
        ),
      ],
    );
  }
}
