import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/alcohol.dart';
import '../platform/src/platform_bottom_sheet.dart';
import 'drinked_dialog_cubit.dart';

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
    return BlocProvider<DrinkedDialogCubit>(
      create: (context) => DrinkedDialogCubit(),
      lazy: false,
      child: const DrinkedDialogBody(),
    );
  }
}

class DrinkedDialogBody extends StatefulWidget {
  const DrinkedDialogBody({super.key});

  @override
  State<DrinkedDialogBody> createState() => _DrinkedDialogBodyState();
}

class _DrinkedDialogBodyState extends State<DrinkedDialogBody> {
  bool _showDetails = false;

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.viewInsetsOf(context);
    final padding = MediaQuery.paddingOf(context);

    return Material(
      type: MaterialType.transparency,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: CustomScrollView(
          slivers: [
            const SliverPersistentHeader(
              delegate: CupertinoSliverAppBar(),
              pinned: true,
            ),
            SliverToBoxAdapter(
              child: CupertinoListSection.insetGrouped(
                additionalDividerMargin: 0,
                backgroundColor: Colors.transparent,
                children: const [
                  SelectAlcoholField(),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: CupertinoListSection.insetGrouped(
                additionalDividerMargin: 0,
                backgroundColor: Colors.transparent,
                children: [
                  CupertinoListTile(
                    onTap: () => setState(() {
                      _showDetails = !_showDetails;
                    }),
                    title: const Text('Подробнее'),
                    subtitle: const Text('Опционально'),
                    trailing: AnimatedRotation(
                      turns: _showDetails ? 0.25 : 0,
                      duration: kThemeAnimationDuration,
                      curve: Curves.easeIn,
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: AnimatedSwitcher(
                duration: kThemeAnimationDuration,
                switchInCurve: Curves.easeIn,
                switchOutCurve: Curves.easeOut,
                transitionBuilder: (child, anim) => SizeTransition(
                  sizeFactor: anim,
                  axis: Axis.vertical,
                  axisAlignment: -1.0,
                  child: child,
                ),
                child: _showDetails
                    ? CupertinoListSection.insetGrouped(
                        additionalDividerMargin: 0,
                        backgroundColor: Colors.transparent,
                        children: const [
                          VolumeField(),
                          AlcoholByVolumeField(),
                        ],
                      )
                    : const SizedBox(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                  20.0,
                  20.0,
                  20.0,
                  10.0,
                ),
                child: CupertinoButton.filled(
                  child: const Text('Добавить'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: padding.bottom + viewInsets.bottom),
            ),
          ],
        ),
      ),
    );
  }
}

class SelectAlcoholField extends StatefulWidget {
  const SelectAlcoholField({super.key});

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
      title: const Text('Что пьём?'),
      bottom: SizedBox(
        height: 160,
        child: PageView.builder(
          controller: _controller,
          onPageChanged: (i) {
            final selectedAlcohol = alcohol[i % alcohol.length];
            context.read<DrinkedDialogCubit>().setAlcohol(selectedAlcohol);
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

class VolumeField extends StatelessWidget {
  const VolumeField({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      title: Row(
        children: [
          const Text('Объем (мл.)'),
          Expanded(
            child: TextField(
              textAlign: TextAlign.end,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              keyboardType: const TextInputType.numberWithOptions(
                signed: false,
                decimal: false,
              ),
              onChanged: (volumeStr) {
                final volume = int.tryParse(volumeStr);
                if (volume != null) {
                  context.read<DrinkedDialogCubit>().setVolume(volume);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AlcoholByVolumeField extends StatelessWidget {
  const AlcoholByVolumeField({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      title: Row(
        children: [
          const Text('Крепость (%)'),
          Expanded(
            child: TextField(
              textAlign: TextAlign.end,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              keyboardType: const TextInputType.numberWithOptions(
                signed: false,
                decimal: false,
              ),
              onChanged: (abvStr) {
                final abv = double.tryParse(abvStr);
                if (abv != null) {
                  context.read<DrinkedDialogCubit>().setAlcoholByVolume(abv);
                }
              },
            ),
          ),
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

class CupertinoSliverAppBar extends SliverPersistentHeaderDelegate {
  const CupertinoSliverAppBar();

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return CupertinoNavigationBar(
      leading: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Отменить'),
      ),
      middle: const Text('Алкоголь'),
    );
  }

  @override
  double get maxExtent => 44.0;

  @override
  double get minExtent => 44.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
