import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectWeightScreen extends StatelessWidget {
  const SelectWeightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(),
      body: Center(
        child: ColoredBox(
          color: Colors.white,
          child: SizedBox(
            height: 144,
            child: _Selector(),
          ),
        ),
      ),
    );
  }
}

class _Selector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          scrollDirection: Axis.horizontal,
          physics: const PageScrollPhysics().applyTo(const ScrollPhysics()),
          slivers: [
            SliverCrossAxisGroup(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.only(left: 33),
                  sliver: SliverList.builder(
                    itemCount: 300 * 10,
                    itemBuilder: (context, i) {
                      final isBig = i % 10 == 0;

                      return Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: SizedBox(
                            width: 2,
                            height: isBig ? 50 : 30,
                            child: ColoredBox(
                              color: isBig
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade300,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.only(left: 3),
                  sliver: SliverList.builder(
                    itemCount: 300,
                    itemBuilder: (context, i) => SizedBox(
                      width: 60,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          '$i',
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        Center(
          child: SizedBox(
            width: 2,
            height: 60,
            child: ColoredBox(
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }
}

class PageScrollPhysics extends ScrollPhysics {
  /// Creates physics for a [PageView].
  const PageScrollPhysics({super.parent});

  @override
  PageScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return PageScrollPhysics(parent: buildParent(ancestor));
  }

  double _getPage(ScrollMetrics position) {
    return position.pixels / 6;
  }

  double _getPixels(ScrollMetrics position, double page) {
    return page * 6;
  }

  double _getTargetPixels(
      ScrollMetrics position, Tolerance tolerance, double velocity) {
    double page = _getPage(position);
    double pagesToAdd = (velocity / 6).abs();
    pagesToAdd = min(4000, pagesToAdd);
    if (velocity < -tolerance.velocity) {
      page -= pagesToAdd;
    } else if (velocity > tolerance.velocity) {
      page += velocity / 6;
    }
    return _getPixels(position, page.roundToDouble());
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    // If we're out of range and not headed back in range, defer to the parent
    // ballistics, which should put us back in range at a page boundary.
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }
    final Tolerance tolerance = toleranceFor(position);
    final double target = _getTargetPixels(position, tolerance, velocity)
        .clamp(position.minScrollExtent, position.maxScrollExtent);
    if (target != position.pixels) {
      return ScrollSpringSimulation(spring, position.pixels, target, velocity,
          tolerance: tolerance);
    }
    return null;
  }

  @override
  bool get allowImplicitScrolling => false;
}
