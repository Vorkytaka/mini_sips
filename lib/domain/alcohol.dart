import 'package:flutter/material.dart';

@immutable
class Alcohol {
  final String id;
  final String name;
  final IconData icon;

  const Alcohol({
    required this.id,
    required this.name,
    required this.icon,
  });

  static const Alcohol any = Alcohol(
    id: 'any',
    name: 'Any alcohol',
    icon: Icons.water_drop_outlined,
  );
}

const alcohol = [
  Alcohol.any,
  Alcohol(id: 'beer', name: 'Beer', icon: Icons.stay_current_portrait),
  Alcohol(id: 'wine', name: 'Wine', icon: Icons.schedule),
  Alcohol(id: 'spirits', name: 'Spirits', icon: Icons.fastfood),
  Alcohol(id: 'cocktails', name: 'Cocktails', icon: Icons.compass_calibration),
];
