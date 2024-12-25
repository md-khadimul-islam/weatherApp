import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/temp_unit_provider.dart';
import '../providers/weather_provider.dart';

class SettingTools extends ConsumerWidget {
  const SettingTools({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final temperatureUnit = ref.watch(temperatureUnitProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Show temperature in Fahrenheit'),
            subtitle: const Text('Default is Celsius'),
            value: temperatureUnit.isFahrenheit,
            onChanged: (value) async {
              await ref
                  .read(temperatureUnitProvider.notifier)
                  .toggleTemperatureUnit(value);
              ref.read(weatherProvider.notifier).getData();
            },
          ),
        ],
      ),
    );
  }
}
