import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/either.dart';
import '../domain/alcohol.dart';
import '../manager/data_manager.dart';

class DataCubit extends Cubit<DataState> {
  final DataManager dataManager;

  DataCubit({
    required this.dataManager,
  }) : super(const DataState.init());

  Future<void> init() async {
    await dataManager.getLastYearDrinks().fold(
          ifLeft: (_) => emit(state.copyWith(
            status: DataStateStatus.fail,
          )),
          ifRight: (alcohol) => emit(state.copyWith(
            alcohol: alcohol,
            status: DataStateStatus.success,
          )),
        );
  }
}

enum DataStateStatus {
  loading,
  fail,
  success,
}

@immutable
class DataState {
  final List<Alcohol> alcohol;
  final DataStateStatus status;

  const DataState({
    required this.alcohol,
    required this.status,
  });

  const DataState.init()
      : alcohol = const [],
        status = DataStateStatus.loading;

  DataState copyWith({
    List<Alcohol>? alcohol,
    DataStateStatus? status,
  }) =>
      DataState(
        alcohol: alcohol ?? this.alcohol,
        status: status ?? this.status,
      );
}
