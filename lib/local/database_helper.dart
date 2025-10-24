import 'package:shared_preferences/shared_preferences.dart';

class StringListDatabaseHelper {
  static final StringListDatabaseHelper _instance =
      StringListDatabaseHelper._internal();

  factory StringListDatabaseHelper() => _instance;

  StringListDatabaseHelper._internal();

  static const String _key = 'my_string_list';
  SharedPreferences? _prefs;

  /// Initialize SharedPreferences once
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
    if (!_prefs!.containsKey(_key)) {
      await _prefs!.setStringList(_key, []);
    }
  }

  /// Add a string to the list
  Future<void> add(String value) async {
    await init(); // Ensure prefs is initialized
    final List<String> currentList = _prefs!.getStringList(_key) ?? [];
    currentList.add(value);
    await _prefs!.setStringList(_key, currentList);
  }

  /// Remove a string from the list
  Future<void> remove(String value) async {
    await init(); // Ensure prefs is initialized
    final List<String> currentList = _prefs!.getStringList(_key) ?? [];
    currentList.remove(value);
    await _prefs!.setStringList(_key, currentList);
  }

  /// Get the current list
  Future<List<String>> getList() async {
    await init(); // Ensure prefs is initialized
    return _prefs!.getStringList(_key) ?? [];
  }
}
