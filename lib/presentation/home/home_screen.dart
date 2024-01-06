import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                Text('123'),
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
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (startWidget != null) Expanded(child: startWidget),
            if (endWidget != null) Expanded(child: endWidget),
          ],
        ),
      ],
    );
  }
}
