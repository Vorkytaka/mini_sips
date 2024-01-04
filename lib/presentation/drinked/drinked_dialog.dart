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
  Alcohol _selectedAlcohol = alcohol.first;
  DateTime? _selectedDateTime;

  bool _showDetails = false;
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
              SelectAlcoholField(
                name: _selectedAlcohol.name,
                onAlcoholChanged: (alco) => setState(() {
                  _selectedAlcohol = alco;
                }),
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
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: child,
              ),
              child: _showDetails
                  ? CupertinoListSection.insetGrouped(
                      additionalDividerMargin: 0,
                      backgroundColor: Colors.transparent,
                      children: [
                        DateTimeField(
                          showPicker: _showDateTimePicker,
                          value: _selectedDateTime?.toIso8601String(),
                          onTap: () => setState(() {
                            _showDateTimePicker = !_showDateTimePicker;
                          }),
                          onDateTimeChanged: (datetime) => setState(() {
                            if (datetime.sameMinutes(_selectedDateTime)) {
                              _selectedDateTime = null;
                            } else {
                              _selectedDateTime = datetime;
                            }
                          }),
                        ),
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

class SelectAlcoholField extends StatefulWidget {
  final String name;
  final ValueChanged<Alcohol> onAlcoholChanged;

  const SelectAlcoholField({
    super.key,
    required this.name,
    required this.onAlcoholChanged,
  });

  @override
  State<SelectAlcoholField> createState() => _SelectAlcoholFieldState();
}

class _SelectAlcoholFieldState extends State<SelectAlcoholField> {
  final _controller = PageController(
    viewportFraction: 0.5,
    initialPage: alcohol.length * 10000,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoListTileWithBottom(
      title: Text('Что пьём?'),
      bottom: SizedBox(
        height: 160,
        child: PageView.builder(
          controller: _controller,
          onPageChanged: (i) {
            final selectedAlcohol = alcohol[i % alcohol.length];
            widget.onAlcoholChanged(selectedAlcohol);
          },
          itemBuilder: (context, i) {
            final index = i % alcohol.length;
            final alco = alcohol[index];

            return GestureDetector(
              onTap: () {
                if (_controller.page == i) {
                  return;
                }

                _controller.animateToPage(
                  i,
                  duration: kThemeAnimationDuration,
                  curve: Curves.easeIn,
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    alco.icon,
                    size: 64,
                  ),
                  const SizedBox(height: 12),
                  Text(alco.name),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class DateTimeField extends StatelessWidget {
  final VoidCallback onTap;
  final bool showPicker;
  final ValueChanged<DateTime> onDateTimeChanged;
  final String? value;

  const DateTimeField({
    super.key,
    required this.onTap,
    required this.showPicker,
    required this.onDateTimeChanged,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoListTileWithBottom(
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
        child: Text(value ?? 'Сейчас'),
      ),
      onTap: onTap,
      bottom: showPicker
          ? SizedBox(
              height: 216,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.dateAndTime,
                maximumDate: DateTime.now().add(const Duration(minutes: 1)),
                onDateTimeChanged: onDateTimeChanged,
              ),
            )
          : null,
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

@immutable
class Alcohol {
  final String id;
  final String name;
  final IconData icon;

  const Alcohol({
    required this.id,
    required this.name,
    required this.icon,
  });
}

const alcohol = [
  Alcohol(id: 'no-matter', name: 'No matter', icon: Icons.water_drop_outlined),
  Alcohol(id: 'beer', name: 'Beer', icon: Icons.stay_current_portrait),
  Alcohol(id: 'wine', name: 'Wine', icon: Icons.schedule),
  Alcohol(id: 'spirits', name: 'Spirits', icon: Icons.fastfood),
  Alcohol(id: 'cocktails', name: 'Cocktails', icon: Icons.compass_calibration),
];

extension on DateTime {
  bool sameMinutes(DateTime? datetime) {
    if (datetime == null) {
      return false;
    }

    return year == datetime.year &&
        month == datetime.month &&
        day == datetime.day &&
        hour == datetime.hour &&
        minute == datetime.minute;
  }
}
