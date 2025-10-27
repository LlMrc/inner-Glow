// Dans votre widget de page (ex: HomePage)
import 'package:flutter/material.dart';
import 'package:nodus_application/utils/theme_notifier.dart';
import 'package:provider/provider.dart';

class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.getTheme.brightness == Brightness.dark;

    return SwitchListTile(
      title: const Text('Mode Sombre'),
      value: isDark,
      onChanged: (value) {
        themeProvider.toggleTheme(
          value,
        ); // Appelle la méthode pour changer et sauvegarder
      },
    );
  }
}
