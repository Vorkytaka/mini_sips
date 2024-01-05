import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../platform.dart';
import 'platform_common.dart';

Future<T?> showPlatformBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool expand = false,
}) {
  final platform = PlatformProvider.of(context);

  if (platform.isCupertino) {
    final cupertinoScaffold = CupertinoScaffold.of(context);
    if (cupertinoScaffold != null) {
      return CupertinoScaffold.showCupertinoModalBottomSheet(
        context: context,
        builder: builder,
        expand: expand,
      );
    } else {
      return showCupertinoModalBottomSheet(
        context: context,
        builder: builder,
        expand: expand,
      );
    }
  } else {
    return showMaterialModalBottomSheet(
      context: context,
      builder: builder,
      expand: expand,
    );
  }
}
