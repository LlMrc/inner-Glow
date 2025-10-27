import 'package:shared_preferences/shared_preferences.dart';

class StringListDatabaseHelper {
  static final StringListDatabaseHelper _instance =
      StringListDatabaseHelper._internal();

  factory StringListDatabaseHelper() => _instance;

  static StringListDatabaseHelper get instance => _instance;

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
    final List<String> currentList = _prefs!.getStringList(_key) ?? [];
    currentList.add(value);
    await _prefs!.setStringList(_key, currentList);
  }

  /// Remove a string from the list
  Future<void> remove(String value) async {
    final List<String> currentList = _prefs!.getStringList(_key) ?? [];
    currentList.remove(value);
    await _prefs!.setStringList(_key, currentList);
  }

  /// Get the current list
  Future<List<String>> getList() async {
    return _prefs!.getStringList(_key) ?? [];
  }

  /// Get the favorite citation list
  Future<List<String>> getFavoriteCitationList() async {
    return _prefs!.getStringList('favorite_citation_list') ?? [];
  }

  /// Add a favorite citation
  Future<void> addFavoriteCitation(String value) async {
    final List<String> currentList = await getFavoriteCitationList();
    currentList.add(value);
    await _prefs!.setStringList('favorite_citation_list', currentList);
  }

  /// Remove a favorite citation
  Future<void> removeFavoriteCitation(String value) async {
    final List<String> currentList = await getFavoriteCitationList();
    currentList.remove(value);
    await _prefs!.setStringList('favorite_citation_list', currentList);
  }
}
