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

  void setNote(String note) => emit(state.copyWith(note: note));

  void setPrice(double price) => emit(state.copyWith(price: price));

  Future<void> add() async {
    emit(state.copyWith(status: DrinkedDialogStatus.loading));

    final alcohol = Alcohol(
      id: state.alcohol.id,
      alcoholByVolume: state.alcoholByVolume,
      volume: state.volume,
      datetime: DateTime.timestamp(),
      note: state.note,
      price: state.price,
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
  final String? note;
  final double? price;

  const DrinkedDialogState({
    required this.status,
    required this.alcohol,
    required this.alcoholByVolume,
    required this.volume,
    required this.note,
    required this.price,
  });

  const DrinkedDialogState.init()
      : status = DrinkedDialogStatus.idle,
        alcohol = AlcoholUI.any,
        alcoholByVolume = null,
        volume = null,
        note = null,
        price = null;

  DrinkedDialogState copyWith({
    DrinkedDialogStatus? status,
    AlcoholUI? alcohol,
    double? alcoholByVolume,
    int? volume,
    String? note,
    double? price,
  }) =>
      DrinkedDialogState(
        status: status ?? this.status,
        alcohol: alcohol ?? this.alcohol,
        alcoholByVolume: alcoholByVolume ?? this.alcoholByVolume,
        volume: volume ?? this.volume,
        note: note ?? this.note,
        price: price ?? this.price,
      );
}
