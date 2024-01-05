import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/alcohol.dart';

class DrinkedDialogCubit extends Cubit<DrinkedDialogState> {
  DrinkedDialogCubit() : super(const DrinkedDialogState.init());

  void setAlcohol(Alcohol alcohol) => emit(state.copyWith(alcohol: alcohol));

  void setAlcoholByVolume(double alcoholByVolume) =>
      emit(state.copyWith(alcoholByVolume: alcoholByVolume));

  void setVolume(int volume) => emit(state.copyWith(volume: volume));
}

@immutable
class DrinkedDialogState {
  final Alcohol alcohol;
  final double? alcoholByVolume;
  final int? volume;

  const DrinkedDialogState({
    required this.alcohol,
    required this.alcoholByVolume,
    required this.volume,
  });

  const DrinkedDialogState.init()
      : alcohol = Alcohol.any,
        alcoholByVolume = null,
        volume = null;

  DrinkedDialogState copyWith({
    Alcohol? alcohol,
    double? alcoholByVolume,
    int? volume,
  }) =>
      DrinkedDialogState(
        alcohol: alcohol ?? this.alcohol,
        alcoholByVolume: alcoholByVolume ?? this.alcoholByVolume,
        volume: volume ?? this.volume,
      );
}
