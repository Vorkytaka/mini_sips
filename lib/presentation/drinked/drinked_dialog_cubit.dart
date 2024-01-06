import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/alcohol.dart';
import '../../manager/data_manager.dart';

class DrinkedDialogCubit extends Cubit<DrinkedDialogState> {
  final DataManager dataManager;

  DrinkedDialogCubit({
    required this.dataManager,
  }) : super(const DrinkedDialogState.init());

  void setAlcohol(AlcoholUI alcohol) => emit(state.copyWith(alcohol: alcohol));

  void setAlcoholByVolume(double alcoholByVolume) =>
      emit(state.copyWith(alcoholByVolume: alcoholByVolume));

  void setVolume(int volume) => emit(state.copyWith(volume: volume));

  Future<void> add() async {
    final alcohol = Alcohol(
      id: state.alcohol.id,
      alcoholByVolume: state.alcoholByVolume,
      volume: state.volume,
    );

    await dataManager.addDrink(alcohol);
  }
}

@immutable
class DrinkedDialogState {
  final AlcoholUI alcohol;
  final double? alcoholByVolume;
  final int? volume;

  const DrinkedDialogState({
    required this.alcohol,
    required this.alcoholByVolume,
    required this.volume,
  });

  const DrinkedDialogState.init()
      : alcohol = AlcoholUI.any,
        alcoholByVolume = null,
        volume = null;

  DrinkedDialogState copyWith({
    AlcoholUI? alcohol,
    double? alcoholByVolume,
    int? volume,
  }) =>
      DrinkedDialogState(
        alcohol: alcohol ?? this.alcohol,
        alcoholByVolume: alcoholByVolume ?? this.alcoholByVolume,
        volume: volume ?? this.volume,
      );
}
