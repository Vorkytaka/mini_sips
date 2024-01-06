import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class Alcohol {
  final String id;
  final double? alcoholByVolume;
  final int? volume;
  final DateTime datetime;
  final String? note;
  final double? price;
  final GeoPoint? location;

  const Alcohol({
    required this.id,
    required this.alcoholByVolume,
    required this.volume,
    required this.datetime,
    required this.note,
    required this.price,
    required this.location,
  });

  Map<String, dynamic> get toJson => {
        'id': id,
        if (alcoholByVolume != null) 'alcohol_by_volume': alcoholByVolume,
        if (volume != null) 'volume': volume,
        'datetime': datetime,
        if (note != null && note!.isNotEmpty) 'note': note,
        if (price != null) 'price': price,
        if (location != null) 'location': location,
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
