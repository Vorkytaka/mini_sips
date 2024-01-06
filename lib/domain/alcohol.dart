import 'package:flutter/material.dart';

@immutable
class Alcohol {
  final String id;
  final double? alcoholByVolume;
  final int? volume;

  const Alcohol({
    required this.id,
    required this.alcoholByVolume,
    required this.volume,
  });

  Map<String, dynamic> get toJson => {
        'id': id,
        if (alcoholByVolume != null) 'alcohol_by_volume': alcoholByVolume,
        if (volume != null) 'volume': volume,
      };
}

@immutable
class AlcoholUI {
  final String id;
  final String name;
  final IconData icon;

  const AlcoholUI({
    required this.id,
    required this.name,
    required this.icon,
  });

  static const AlcoholUI any = AlcoholUI(
    id: 'any',
    name: 'Any alcohol',
    icon: Icons.water_drop_outlined,
  );
}

const alcohol = [
  AlcoholUI.any,
  AlcoholUI(id: 'beer', name: 'Beer', icon: Icons.stay_current_portrait),
  AlcoholUI(id: 'wine', name: 'Wine', icon: Icons.schedule),
  AlcoholUI(id: 'spirits', name: 'Spirits', icon: Icons.fastfood),
  AlcoholUI(
      id: 'cocktails', name: 'Cocktails', icon: Icons.compass_calibration),
];
