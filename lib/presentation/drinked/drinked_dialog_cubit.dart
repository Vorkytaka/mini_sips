import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/bloc_effect.dart';
import '../../common/either.dart';
import '../../domain/alcohol.dart';
import '../../manager/data_manager.dart';

enum DrinkedDialogEffect {
  success,
}

class DrinkedDialogCubit extends Cubit<DrinkedDialogState>
    with BlocEffectStream<DrinkedDialogState, DrinkedDialogEffect> {
  final DataManager dataManager;

  DrinkedDialogCubit({
    required this.dataManager,
  }) : super(const DrinkedDialogState.init());

  void setAlcohol(AlcoholUI alcohol) => emit(state.copyWith(alcohol: alcohol));

  void setAlcoholByVolume(double alcoholByVolume) =>
      emit(state.copyWith(alcoholByVolume: alcoholByVolume));

  void setVolume(int volume) => emit(state.copyWith(volume: volume));

  Future<void> add() async {
    emit(state.copyWith(status: DrinkedDialogStatus.loading));

    final alcohol = Alcohol(
      id: state.alcohol.id,
      alcoholByVolume: state.alcoholByVolume,
      volume: state.volume,
    );

    await dataManager.addDrink(alcohol).fold(
      ifLeft: (_) {
        emit(state.copyWith(status: DrinkedDialogStatus.fail));
      },
      ifRight: (_) {
        sendEffect(DrinkedDialogEffect.success);
        emit(state.copyWith(status: DrinkedDialogStatus.success));
      },
    );
  }
}

enum DrinkedDialogStatus {
  idle,
  loading,
  success,
  fail,
}

@immutable
class DrinkedDialogState {
  final DrinkedDialogStatus status;
  final AlcoholUI alcohol;
  final double? alcoholByVolume;
  final int? volume;

  const DrinkedDialogState({
    required this.status,
    required this.alcohol,
    required this.alcoholByVolume,
    required this.volume,
  });

  const DrinkedDialogState.init()
      : status = DrinkedDialogStatus.idle,
        alcohol = AlcoholUI.any,
        alcoholByVolume = null,
        volume = null;

  DrinkedDialogState copyWith({
    DrinkedDialogStatus? status,
    AlcoholUI? alcohol,
    double? alcoholByVolume,
    int? volume,
  }) =>
      DrinkedDialogState(
        status: status ?? this.status,
        alcohol: alcohol ?? this.alcohol,
        alcoholByVolume: alcoholByVolume ?? this.alcoholByVolume,
        volume: volume ?? this.volume,
      );
}
