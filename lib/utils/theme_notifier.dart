// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Écoute les changements du ThemeProvider
//     return Consumer<ThemeProvider>(
//       builder: (context, themeProvider, child) {
//         return MaterialApp(
//           title: 'Theme Demo',
//           theme: themeProvider.getTheme, // Applique le thème actuel
//           home: const HomePage(),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _currentTheme = ThemeData.light(); // Thème par défaut
  static const String _themeKey = 'isDarkTheme';

  ThemeProvider() {
    _loadTheme();
  }

  ThemeData get getTheme => _currentTheme;

  // 1. Charger le thème depuis SharedPreferences au démarrage
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_themeKey) ?? false;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: isDark ? Brightness.dark : Brightness.light,
    );

    _currentTheme = ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true, // si tu utilises Material 3
    );

    notifyListeners(); // Informe les widgets que le thème a changé
  }

  // 2. Changer le thème et le sauvegarder dans SharedPreferences
  void toggleTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    _currentTheme = isDark ? ThemeData.dark() : ThemeData.light();
    await prefs.setBool(_themeKey, isDark); // Sauvegarde
    notifyListeners(); // Informe l'interface
  }
}
