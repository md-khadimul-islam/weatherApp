import 'dart:convert';
import 'dart:developer';

import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod/riverpod.dart';

import '../models/current_weather.dart';
import '../models/forecast_weather.dart';
import '../utils/constant.dart';
import '../utils/helper_function.dart';

enum LocationConversionStatus {
  success,
  failed,
}

class WeatherState {
  final CurrentWeatherResponse? currentWeather;
  final ForecastWeatherResponse? forecastWeather;
  final String unit;
  final String unitSymbol;
  final bool showGetLocationFromCityName;
  final double latitude;
  final double longitude;
  final bool isLoading;

  const WeatherState({
    this.currentWeather,
    this.forecastWeather,
    this.unit = metric,
    this.unitSymbol = celsius,
    this.showGetLocationFromCityName = false,
    this.latitude = 23.8109,
    this.longitude = 90.3654,
    this.isLoading = false,
  });

  WeatherState copyWith({
    CurrentWeatherResponse? currentWeather,
    ForecastWeatherResponse? forecastWeather,
    String? unit,
    String? unitSymbol,
    bool? showGetLocationFromCityName,
    double? latitude,
    double? longitude,
    bool? isLoading,
  }) {
    return WeatherState(
      currentWeather: currentWeather ?? this.currentWeather,
      forecastWeather: forecastWeather ?? this.forecastWeather,
      unit: unit ?? this.unit,
      unitSymbol: unitSymbol ?? this.unitSymbol,
      showGetLocationFromCityName:
          showGetLocationFromCityName ?? this.showGetLocationFromCityName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class WeatherNotifier extends StateNotifier<WeatherState> {
  WeatherNotifier() : super(const WeatherState());

  final String baseUrl = 'https://api.openweathermap.org/data/2.5/';

  Future<void> getData() async {
    if (!state.showGetLocationFromCityName) {
      final position = await _determinePosition();
      state = state.copyWith(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    }
    await _getCurrentData();
    await _getForecastData();
  }

  Future<void> _getCurrentData() async {
    await _updateTempUnit();
    final endUrl =
        'weather?lat=${state.latitude}&lon=${state.longitude}&appid=$apiKey&units=${state.unit}';
    final url = Uri.parse('$baseUrl$endUrl');
    try {
      final response = await http.get(url);
      final json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final weather = CurrentWeatherResponse.fromJson(json);
        state = state.copyWith(currentWeather: weather);
      }
    } catch (error) {
      log(error.toString());
    }
  }

  Future<void> _getForecastData() async {
    await _updateTempUnit();
    final endUrl =
        'forecast?lat=${state.latitude}&lon=${state.longitude}&appid=$apiKey&units=${state.unit}';
    final url = Uri.parse('$baseUrl$endUrl');
    try {
      final response = await http.get(url);
      final json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final forecast = ForecastWeatherResponse.fromJson(json);
        state = state.copyWith(forecastWeather: forecast);
      }
    } catch (error) {
      log(error.toString());
    }
  }

  Future<LocationConversionStatus> convertCityToLatLng(String city) async {
    try {
      final locationList = await geo.locationFromAddress(city);
      if (locationList.isNotEmpty) {
        final location = locationList.first;
        state = state.copyWith(
          latitude: location.latitude,
          longitude: location.longitude,
          showGetLocationFromCityName: true,
        );
        await getData();
        return LocationConversionStatus.success;
      } else {
        return LocationConversionStatus.failed;
      }
    } catch (error) {
      return LocationConversionStatus.failed;
    }
  }

  Future<void> _updateTempUnit() async {
    final status = await getTempUnitStatus();
    state = state.copyWith(
      unit: status ? imperial : metric,
      unitSymbol: status ? fahrenheit : celsius,
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}

final weatherProvider =
    StateNotifierProvider<WeatherNotifier, WeatherState>((ref) {
  return WeatherNotifier();
});
