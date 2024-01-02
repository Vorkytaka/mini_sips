import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../platform.dart';
import 'platform_common.dart';

Future<void> showPlatformBottomSheet({
  required BuildContext context,
  required WidgetBuilder builder,
}) {
  final platform = PlatformProvider.of(context);

  if (platform.isCupertino) {
    return CupertinoScaffold.showCupertinoModalBottomSheet(
      context: context,
      builder: builder,
    );
  } else {
    return showMaterialModalBottomSheet(
      context: context,
      builder: builder,
    );
  }
}
