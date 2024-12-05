import 'package:shared_preferences/shared_preferences.dart';

import './preferences_base.dart';

class Preferences implements BasePreferences {
  static Preferences instance = Preferences._();

  final Future<SharedPreferences> _prefs;

  Preferences._() : _prefs = SharedPreferences.getInstance();

  @override
  Future<int?> getInt(String key) async {
    return (await _prefs).getInt(key);
  }

  @override
  Future<int> getIntOrElse(String key, int defaultValue) async {
    return (await _prefs).getInt(key) ?? defaultValue;
  }

  @override
  Future<bool?> getBool(String key) async {
    return (await _prefs).getBool(key);
  }

  @override
  Future<bool> getBoolOrElse(String key, bool defaultValue) async {
    return (await _prefs).getBool(key) ?? defaultValue;
  }

  @override
  Future<bool> setBool(String key, bool value) async {
    return (await _prefs).setBool(key, value);
  }

  @override
  Future<double?> getDouble(String key) async {
    return (await _prefs).getDouble(key);
  }

  @override
  Future<double> getDoubleOrElse(String key, double defaultValue) async {
    return (await _prefs).getDouble(key) ?? defaultValue;
  }

  @override
  Future<String?> getString(String key) async {
    return (await _prefs).getString(key);
  }

  @override
  Future<String> getStringOrElse(String key, String defaultValue) async {
    return (await _prefs).getString(key) ?? defaultValue;
  }

  @override
  Future<bool> setString(String key, String value) async {
    return (await _prefs).setString(key, value);
  }

  @override
  Future<bool> putBoolean(String key, bool value) async {
    return (await _prefs).setBool(key, value);
  }

  @override
  Future<bool> setInt(String key, int value) async {
    return (await _prefs).setInt(key, value);
  }
}
