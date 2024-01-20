import 'package:flutter/foundation.dart';

enum AppStyle {
  tracking,
  quitting,
}

@immutable
class UserData {
  final AppStyle appStyle;

  const UserData({
    required this.appStyle,
  });
}
