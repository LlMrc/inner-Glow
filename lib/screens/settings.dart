// Importez votre AppLocalizations si vous l'utilisez pour les traductions
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nodus_application/l10n/app_localizations.dart';
import 'package:nodus_application/widgets/switch_theme.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // Méthode simulée pour naviguer vers la page Premium
  void _navigateToPremiumPage(BuildContext context) {
    // Navigator.push(context, MaterialPageRoute(builder: (context) => PremiumPage()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Naviguer vers la page Premium')),
    );
    if (kDebugMode) {
      print("Naviguer vers la page Premium");
    }
  }

  // Méthode simulée pour envoyer un feedback
  void _sendFeedback(BuildContext context) {
    // Ici, vous ouvririez un email client ou un formulaire in-app
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ouvrir la boîte de dialogue de feedback')),
    );
    if (kDebugMode) {
      print("Ouvrir la boîte de dialogue de feedback");
    }
  }

  // Méthode simulée pour ouvrir les termes et services
  void _openTermsAndServices(BuildContext context) {
    // Navigator.push(context, MaterialPageRoute(builder: (context) => TermsAndServicesPage()));
    // Ou ouvrir un lien web avec `url_launcher`
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ouvrir les termes et services')),
    );
    print("Ouvrir les termes et services");
  }

  @override
  Widget build(BuildContext context) {
    // Utilisez AppLocalizations.of(context)!.<votre_clef_de_traduction> pour tous les textes
    // Pour cet exemple, j'utilise des chaînes littérales
    final bool isPremiumUser =
        false; // Remplacez par votre logique de vérification Premium

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settingsTitle),
        backgroundColor: Theme.of(
          context,
        ).colorScheme.primary, // Couleur de votre thème
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // --- Section Abonnement Premium ---
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(bottom: 20),
            color: Theme.of(
              context,
            ).colorScheme.secondaryContainer, // Couleur d'accentuation
            child: InkWell(
              // Rendre la carte cliquable
              onTap: (isPremiumUser == false)
                  ? () => _navigateToPremiumPage(context)
                  : null,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isPremiumUser == true
                          ? AppLocalizations.of(context)!.premiumActive
                          : AppLocalizations.of(context)!.premiumInactive,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isPremiumUser == true
                            ? Theme.of(context).colorScheme.onSecondaryContainer
                            : Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (isPremiumUser == false) ...[
                      Text(
                        AppLocalizations.of(
                          context,
                        )!.premiumInactiveDescription,
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer
                              .withValues(alpha: 0.8),
                        ),
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton.icon(
                        onPressed: () => _navigateToPremiumPage(context),
                        icon: const Icon(Icons.workspace_premium),
                        label: Text(
                          AppLocalizations.of(context)!.premiumButton,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary, // Couleur principale
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.onPrimary, // Texte sur le bouton
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ] else ...[
                      Text(
                        AppLocalizations.of(context)!.premiumActiveDescription,
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer
                              .withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),

          // --- Section Général ---
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              AppLocalizations.of(context)!.general,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                // Exemple pour le changement de langue (si implémenté)
                // ListTile(
                //   leading: const Icon(Icons.language),
                //   title: Text(AppLocalizations.of(context)!.language),
                //   trailing: DropdownButton<Locale>( /* Votre DropdownButton ici */ ),
                //   onTap: () { /* Ouvre la sélection de langue ou navigue */ },
                // ),
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text(
                    'Notifications',
                  ), // AppLocalizations.of(context)!.notifications
                  trailing: Switch(
                    value:
                        true, // Remplacez par l'état réel de vos notifications
                    onChanged: (bool value) {
                      // Logique pour activer/désactiver les notifications

                      print("Notifications: $value");
                    },
                  ),
                ),
                ThemeSwitcher(), // AppLocalizations.of(context)!.darkMode
              ],
            ),
          ),

          // --- Section Support ---
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              AppLocalizations.of(context)!.support,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.feedback),
                  title: Text(
                    AppLocalizations.of(context)!.sendFeedback,
                  ), // AppLocalizations.of(context)!.sendFeedback
                  onTap: () => _sendFeedback(context),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                ),
                ListTile(
                  leading: const Icon(Icons.description),
                  title: Text(
                    AppLocalizations.of(context)!.termsAndServices,
                  ), // AppLocalizations.of(context)!.termsAndServices
                  onTap: () => _openTermsAndServices(context),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                ),
                ListTile(
                  leading: const Icon(Icons.privacy_tip),
                  title: Text(AppLocalizations.of(context)!.privacyPolicy),
                  onTap: () {
                    // _openPrivacyPolicy(context);
                    if (kDebugMode) {
                      print("Ouvrir la politique de confidentialité");
                    }
                  },
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                ),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: Text(AppLocalizations.of(context)!.aboutApp),
                  onTap: () {
                    // _openAboutApp(context);
                    if (kDebugMode) {
                      print("Ouvrir la page 'À Propos'");
                    }
                  },
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
