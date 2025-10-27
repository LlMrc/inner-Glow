import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr')
  ];

  /// The application title
  ///
  /// In en, this message translates to:
  /// **'inner Glow'**
  String get appTitle;

  /// No description provided for @howAreYouToday.
  ///
  /// In en, this message translates to:
  /// **'How are you feeling today?✨'**
  String get howAreYouToday;

  /// No description provided for @happy.
  ///
  /// In en, this message translates to:
  /// **'Happy'**
  String get happy;

  /// No description provided for @sad.
  ///
  /// In en, this message translates to:
  /// **'Sad'**
  String get sad;

  /// No description provided for @quoteOfTheDay.
  ///
  /// In en, this message translates to:
  /// **'Quote of the Day'**
  String get quoteOfTheDay;

  /// No description provided for @dailyQuote.
  ///
  /// In en, this message translates to:
  /// **'Your daily quote goes here.'**
  String get dailyQuote;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @addToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Add to Favorites'**
  String get addToFavorites;

  /// No description provided for @shareText.
  ///
  /// In en, this message translates to:
  /// **'Share text'**
  String get shareText;

  /// No description provided for @shareImage.
  ///
  /// In en, this message translates to:
  /// **'Share image'**
  String get shareImage;

  /// No description provided for @gradientEditor.
  ///
  /// In en, this message translates to:
  /// **'Change gradient'**
  String get gradientEditor;

  /// No description provided for @fontEditor.
  ///
  /// In en, this message translates to:
  /// **'Font'**
  String get fontEditor;

  /// No description provided for @backgroundEditor.
  ///
  /// In en, this message translates to:
  /// **'Background'**
  String get backgroundEditor;

  /// No description provided for @sampleText.
  ///
  /// In en, this message translates to:
  /// **'This is a sample quote'**
  String get sampleText;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @angry.
  ///
  /// In en, this message translates to:
  /// **'Angry'**
  String get angry;

  /// No description provided for @scared.
  ///
  /// In en, this message translates to:
  /// **'Scared'**
  String get scared;

  /// No description provided for @tired.
  ///
  /// In en, this message translates to:
  /// **'Tired'**
  String get tired;

  /// No description provided for @sick.
  ///
  /// In en, this message translates to:
  /// **'Sick'**
  String get sick;

  /// No description provided for @inLove.
  ///
  /// In en, this message translates to:
  /// **'In Love'**
  String get inLove;

  /// No description provided for @stressed.
  ///
  /// In en, this message translates to:
  /// **'Stressed'**
  String get stressed;

  /// No description provided for @calm.
  ///
  /// In en, this message translates to:
  /// **'Calm'**
  String get calm;

  /// No description provided for @inspired.
  ///
  /// In en, this message translates to:
  /// **'Inspired'**
  String get inspired;

  /// No description provided for @motivated.
  ///
  /// In en, this message translates to:
  /// **'Motivated'**
  String get motivated;

  /// No description provided for @thoughtful.
  ///
  /// In en, this message translates to:
  /// **'Thoughtful'**
  String get thoughtful;

  /// No description provided for @termsAndServices.
  ///
  /// In en, this message translates to:
  /// **'Terms and Services'**
  String get termsAndServices;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About the App'**
  String get aboutApp;

  /// No description provided for @sendFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send Feedback'**
  String get sendFeedback;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @premiumActiveDescription.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your support! Enjoy all premium features to the fullest.'**
  String get premiumActiveDescription;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @premiumButton.
  ///
  /// In en, this message translates to:
  /// **'Unlock Premium'**
  String get premiumButton;

  /// No description provided for @premiumInactiveDescription.
  ///
  /// In en, this message translates to:
  /// **'Access all exclusive features, an unlimited quote catalog, and enjoy an ad-free experience.'**
  String get premiumInactiveDescription;

  /// No description provided for @premiumActive.
  ///
  /// In en, this message translates to:
  /// **'Premium Subscription Active 👑'**
  String get premiumActive;

  /// No description provided for @premiumInactive.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium! 🚀'**
  String get premiumInactive;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fr': return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
