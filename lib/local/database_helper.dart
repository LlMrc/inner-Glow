import 'package:shared_preferences/shared_preferences.dart';

class StringListDatabaseHelper {
  static final StringListDatabaseHelper _instance =
      StringListDatabaseHelper._internal();

  factory StringListDatabaseHelper() => _instance;

  static StringListDatabaseHelper get instance => _instance;

  StringListDatabaseHelper._internal();

  static const String _mainKey = 'my_string_list';
  static const String _favoriteKey = 'favorite_citation_list';

  SharedPreferences? _prefs;

  /// Initialise SharedPreferences si nécessaire
  Future<void> _ensureInitialized() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Initialise la liste principale si elle n'existe pas
  Future<void> init() async {
    await _ensureInitialized();
    _prefs!.setStringList(_mainKey, _prefs!.getStringList(_mainKey) ?? []);
  }

  /// Méthode générique pour ajouter ou retirer une valeur d'une liste
  Future<void> _updateList(String key, String value, {bool add = true}) async {
    await _ensureInitialized();
    final List<String> list = _prefs!.getStringList(key) ?? [];
    if (add) {
      if (!list.contains(value)) list.add(value);
    } else {
      list.remove(value);
    }
    await _prefs!.setStringList(key, list);
  }

  /// Ajoute une valeur à la liste principale
  Future<void> add(String value) async =>
      _updateList(_mainKey, value, add: true);

  /// Supprime une valeur de la liste principale
  Future<void> remove(String value) async =>
      _updateList(_mainKey, value, add: false);

  /// Récupère la liste principale
  Future<List<String>> getList() async {
    await _ensureInitialized();
    return _prefs!.getStringList(_mainKey) ?? [];
  }

  /// Récupère la liste des citations favorites
  Future<List<String>> getFavoriteCitationList() async {
    await _ensureInitialized();
    return _prefs!.getStringList(_favoriteKey) ?? [];
  }

  /// Ajoute une citation favorite
  Future<void> addFavoriteCitation(String value) async =>
      _updateList(_favoriteKey, value, add: true);

  /// Supprime une citation favorite
  Future<void> removeFavoriteCitation(String value) async =>
      _updateList(_favoriteKey, value, add: false);
}
