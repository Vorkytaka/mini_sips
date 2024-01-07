import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/alcohol.dart';
import '../data_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const CupertinoSliverNavigationBar(
            largeTitle: Text('Сводка'),
          ),
          SliverToBoxAdapter(
            child: CupertinoListSection.insetGrouped(
              additionalDividerMargin: 0,
              backgroundColor: Colors.transparent,
              children: const [
                PreviousDrinkWidget(),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: CupertinoListSection.insetGrouped(
              additionalDividerMargin: 0,
              backgroundColor: Colors.transparent,
              children: const [
                MaxDrinkedPeriodWidget(),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: CupertinoListSection.insetGrouped(
              additionalDividerMargin: 0,
              backgroundColor: Colors.transparent,
              children: const [
                MaxNotDrinkedPeriodWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CupertinoCard extends StatelessWidget {
  final Widget? icon;
  final Widget title;
  final Widget? trailing;
  final Widget? bottom;
  final VoidCallback? onTap;

  const CupertinoCard({
    super.key,
    this.icon,
    required this.title,
    this.trailing,
    this.bottom,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cupertinoTheme = CupertinoTheme.of(context);

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsetsDirectional.only(
              top: 14,
              bottom: 14,
              start: 20.0,
              end: 14.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (icon != null) ...[
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: Center(
                                child: IconTheme.merge(
                                  data: const IconThemeData(
                                    size: 16,
                                  ),
                                  child: icon!,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                          DefaultTextStyle(
                            style: cupertinoTheme.textTheme.textStyle,
                            child: title,
                          ),
                        ],
                      ),
                    ),
                    if (trailing != null) trailing!,
                  ],
                ),
                if (bottom != null) ...[
                  const SizedBox(height: 12),
                  bottom!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PreviousDrinkWidget extends StatelessWidget {
  const PreviousDrinkWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DataCubit, DataState, Alcohol?>(
      selector: (state) =>
          state.alcohol.isNotEmpty ? state.alcohol.first : null,
      builder: (context, alcohol) {
        if (alcohol == null) {
          return SizedBox();
        }

        return CupertinoCard(
          icon: Icon(Icons.undo),
          title: Text('Предыдущий'),
          bottom: Text(
              'В последний раз вы пили ${alcohol.datetime.toIso8601String()}'),
        );
      },
    );
  }
}

class MaxDrinkedPeriodWidget extends StatelessWidget {
  const MaxDrinkedPeriodWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DataCubit, DataState, int>(
      selector: (state) => state.alcohol.maxConsecutiveDays,
      builder: (context, combo) {
        return CupertinoCard(
          icon: Icon(Icons.undo),
          title: Text('Дней с алкоголем'),
          bottom: Text('$combo'),
        );
      },
    );
  }
}

class MaxNotDrinkedPeriodWidget extends StatelessWidget {
  const MaxNotDrinkedPeriodWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DataCubit, DataState, int>(
      selector: (state) => state.alcohol.maxDateDifference,
      builder: (context, combo) {
        return CupertinoCard(
          icon: Icon(Icons.undo),
          title: Text('Дней без алкоголя'),
          bottom: Text('$combo'),
        );
      },
    );
  }
}

extension on List<Alcohol> {
  int get maxConsecutiveDays {
    if (isEmpty) return 0;

    int maxConsDays = 0;
    int currentConsDays = 0;

    for (int i = 1; i < length; i++) {
      int dateDiff = this[i].datetime.difference(this[i - 1].datetime).inDays;

      if (dateDiff == 1) {
        currentConsDays++;
      } else if (dateDiff > 1) {
        currentConsDays = 0;
      }
      // If dateDiff == 0, this means a duplicate date; skip it

      if (currentConsDays > maxConsDays) {
        maxConsDays = currentConsDays;
      }
    }

    return maxConsDays +
        1; // Add 1 to include the first day of the consecutive days chain
  }

  int get maxDateDifference {
    if (length < 2) return 0;

    int maxDateDiff = 0;

    for (int i = 1; i < length; i++) {
      int dateDiff = this[i].datetime.difference(this[i - 1].datetime).inDays;
      if (dateDiff > maxDateDiff) {
        maxDateDiff = dateDiff;
      }
    }

    return maxDateDiff;
  }
}
