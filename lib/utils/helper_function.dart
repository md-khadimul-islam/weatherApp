import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

String getFormattedDate(int dt, {String pattern = 'MMM dd yyyy HH:mm'}) =>
    DateFormat(pattern)
        .format(DateTime.fromMillisecondsSinceEpoch(dt.toInt() * 1000));

Future<bool> setTempUnitStatus(bool status) async {
  final pref = await SharedPreferences.getInstance();
  return pref.setBool('status', status);
}

Future<bool> getTempUnitStatus() async {
  final pref = await SharedPreferences.getInstance();
  return pref.getBool('status') ?? false;
}
