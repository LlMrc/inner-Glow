// Importez votre AppLocalizations si vous l'utilisez pour les traductions
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nodus_application/l10n/app_localizations.dart';
import 'package:nodus_application/widgets/rate_us.dart';
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
                ThemeSwitcher(), // AppLocalizations.of(context)!.darkMode
                RateUsWidget(),
                SizedBox(height: 12),
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
                  onTap: () => _showFeedbackBottomSheet(context),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                ),
                ListTile(
                  leading: const Icon(Icons.description),
                  title: Text(
                    AppLocalizations.of(context)!.termsAndServices,
                  ), // AppLocalizations.of(context)!.termsAndServices
                  onTap: () => _showTermsServicesBottomSheet(context),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                ),
                ListTile(
                  leading: const Icon(Icons.privacy_tip),
                  title: Text(AppLocalizations.of(context)!.privacyPolicy),
                  onTap: () {
                    _showTermsBottomSheet(context);
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
                    _showTermsBottomSheet(context);
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

  void _showTermsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Terms & Privacy',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text('''
By using this app, you agree to the following terms and conditions. We value your privacy and are committed to protecting your personal information. 

1. **Data Collection**: We may collect usage data to improve the app experience.
2. **Third-Party Services**: Some features may rely on third-party services.
3. **User Responsibility**: You are responsible for maintaining the confidentiality of your account.
4. **Changes to Terms**: We reserve the right to update these terms at any time.

For full details, please visit our website or contact support.
                ''', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Méthode simulée pour ouvrir les termes et services
  void _showFeedbackBottomSheet(BuildContext context) {
    final TextEditingController feedbackController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'We’d love your feedback!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            TextField(
              controller: feedbackController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Tell us what you think...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                String feedback = feedbackController.text.trim();
                if (feedback.isNotEmpty) {
                  // Handle feedback submission logic here
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Thank you for your feedback!')),
                  );
                }
              },
              child: Text('Submit'),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  //terms and services bottom sheet
  void _showTermsServicesBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Terms & Services',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text('''
By using this app, you agree to the following terms and services:

📜 **Terms of Use**
- You must be at least 13 years old to use this app.
- You agree not to misuse or attempt to disrupt the app’s functionality.
- We reserve the right to suspend accounts that violate our policies.

🛠️ **Services Provided**
- Real-time notifications and updates.
- Cloud-based data sync across devices.
- Offline access to essential features.
- Personalized content based on your preferences.

🔒 **Privacy & Data**
- We collect minimal data to improve your experience.
- Your information is never sold to third parties.
- You can manage your data preferences in settings.

These terms may be updated periodically. Continued use of the app implies acceptance of any changes.
                ''', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
