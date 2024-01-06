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
        ],
      ),
    );
  }
}

class CupertinoCard extends StatelessWidget {
  final Widget? icon;
  final Widget title;
  final Widget? trailing;
  final Widget? bottomStart;
  final Widget? bottomEnd;

  const CupertinoCard({
    super.key,
    this.icon,
    required this.title,
    this.trailing,
    this.bottomEnd,
    this.bottomStart,
  });

  @override
  Widget build(BuildContext context) {
    final direction = Directionality.maybeOf(context) ?? TextDirection.ltr;
    final isLtr = direction == TextDirection.ltr;

    final startWidget = isLtr ? bottomStart : bottomEnd;
    final endWidget = isLtr ? bottomEnd : bottomStart;

    final Widget? bottom;
    if (startWidget != null || endWidget != null) {
      bottom = Padding(
        padding: const EdgeInsetsDirectional.only(
          top: 4,
          start: 20.0,
          end: 14.0,
          bottom: 12,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (startWidget != null) Expanded(child: startWidget),
            if (endWidget != null) Expanded(child: endWidget),
          ],
        ),
      );
    } else {
      bottom = null;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CupertinoListTile(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 6),
              ],
              title,
            ],
          ),
          trailing: trailing,
        ),
        if (bottom != null) bottom,
      ],
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
        if(alcohol == null) {
          return SizedBox();
        }

        return CupertinoCard(
          icon: Icon(Icons.undo),
          title: Text('Предыдущий'),
          bottomStart: Text('В последний раз вы пили ${alcohol!.datetime.toIso8601String()}'),
        );
      },
    );
  }
}
