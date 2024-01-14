import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../../dependencies.dart';
import 'cupertino_card.dart';

class LocationPermissionCard extends StatelessWidget {
  const LocationPermissionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LocationPermission>(
      stream: context.read<Dependencies>().locationManager.permissionStream,
      builder: (context, snapshot) {
        final permission = snapshot.data;

        if (permission == null) {
          return const SizedBox();
        }

        if (permission != LocationPermission.denied &&
            permission != LocationPermission.deniedForever) {
          return const SizedBox();
        }

        final cupertinoTheme = CupertinoTheme.of(context);

        final subtitleStyle = cupertinoTheme.textTheme.textStyle.merge(
          TextStyle(
            fontSize: 12,
            color: CupertinoColors.secondaryLabel.resolveFrom(context),
          ),
        );

        return CupertinoListSection.insetGrouped(
          backgroundColor: Colors.transparent,
          children: [
            CupertinoCard(
              title: const Text('Улучшить данные'),
              trailing: GestureDetector(
                onTap: () {},
                child: const SizedBox.square(
                  dimension: 44,
                  child: Icon(Icons.close),
                ),
              ),
              bottom: DefaultTextStyle(
                style: subtitleStyle,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Expanded(
                      child: Text(
                        'Позвольте нам сохранять места где вы пьёте. Можно отключить в настройках.',
                      ),
                    ),
                    CupertinoButton(
                      child: const Text('Разрешить'),
                      onPressed: () => context
                          .read<Dependencies>()
                          .locationManager
                          .requestPermission(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
