import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/helper_function.dart';

class TemperatureUnitState {
  final bool isFahrenheit;

  const TemperatureUnitState({this.isFahrenheit = false});

  TemperatureUnitState copyWith({bool? isFahrenheit}) {
    return TemperatureUnitState(
      isFahrenheit: isFahrenheit ?? this.isFahrenheit,
    );
  }
}

class TemperatureUnitNotifier extends StateNotifier<TemperatureUnitState> {
  TemperatureUnitNotifier() : super(const TemperatureUnitState());

  Future<void> toggleTemperatureUnit(bool value) async {
    state = state.copyWith(isFahrenheit: value);
    await setTempUnitStatus(value);
  }
}

final temperatureUnitProvider =
    StateNotifierProvider<TemperatureUnitNotifier, TemperatureUnitState>((ref) {
  return TemperatureUnitNotifier();
});
