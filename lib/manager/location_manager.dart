import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class LocationManager {
  const LocationManager();

  Future<bool> get isEnabled => Geolocator.isLocationServiceEnabled();

  Future<LocationPermission> get permission => Geolocator.checkPermission();

  Future<LocationPermission> requestPermission() =>
      Geolocator.requestPermission();

  Future<GeoPoint?> getLocation() async {
    final isEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isEnabled) {
      return null;
    }

    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    return Geolocator.getCurrentPosition()
        .then((position) => GeoPoint(position.latitude, position.longitude));
  }
}
