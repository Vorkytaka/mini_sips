import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../common/either.dart';
import '../domain/alcohol.dart';

class DataManager {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  DataManager({
    required this.auth,
    required this.firestore,
  });

  FEither<Exception, void> addDrink(Alcohol alcohol) async {
    final userUid = auth.currentUser?.uid;

    if (userUid == null) {
      return Either.left(Exception('No user found'));
    }

    try {
      final userDocument = firestore.collection('users').doc(userUid);
      final userAlcoholCollection = userDocument.collection('alcohol');

      await userAlcoholCollection.add(alcohol.toJson);

      return Either.right(null);
    } on Exception catch (e) {
      return Either.left(e);
    }
  }

  FEither<Exception, List<Alcohol>> getLastYearDrinks() async {
    final userUid = auth.currentUser?.uid;

    if (userUid == null) {
      return Either.left(Exception('No user found'));
    }

    try {
      final now = DateTime.timestamp();
      final yearBefore = now.copyWith(year: now.year - 1);

      final userDocument = firestore.collection('users').doc(userUid);
      final userAlcoholCollection = userDocument.collection('alcohol');

      final result = await userAlcoholCollection
          .where('datetime', isGreaterThanOrEqualTo: yearBefore)
          .orderBy('datetime', descending: true)
          .get();

      final alcohol = result.docs.map(
        (doc) {
          final data = doc.data();
          final Timestamp timestamp = data['datetime'];
          final datetime = DateTime.fromMicrosecondsSinceEpoch(
            timestamp.microsecondsSinceEpoch,
            isUtc: true,
          );

          return Alcohol(
            id: data['id'],
            alcoholByVolume: data['alcohol_by_volume'],
            volume: data['volume'],
            datetime: datetime,
            note: data['note'],
            price: data['price'],
          );
        },
      ).toList(growable: false);

      return Either.right(alcohol);
    } on Exception catch (e) {
      return Either.left(e);
    }
  }
}
