import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class Citation {
  String id;
  String mood;
  Map<String, String> text;

  Citation({required this.id, required this.mood, required this.text});

  // Convert Citation instance to a Map

  factory Citation.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return Citation(
      id: snapshot.id,
      mood: data?['mood'],
      text: Map<String, String>.from(data?['text']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {'mood': mood, 'text': text};
  }
}

/// CitationHelper class to interact with Firestore

class CitationHelper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath = 'citation';

  // Fetch all citations
  Future<List<Citation>> getAllCitations() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(collectionPath)
          .get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Citation(
          id: doc.id,
          mood: data['mood'],
          text: Map<String, String>.from(data['text']),
        );
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching citations: $e');
      }
      return [];
    }
  }

  // Fetch citations by mood
  Future<List<Citation>> getCitationsByMood(String mood) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(collectionPath)
          .where('mood', isEqualTo: mood)
          .get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Citation(
          id: doc.id,
          mood: data['mood'],
          text: Map<String, String>.from(data['text']),
        );
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching citations by mood: $e');
      }
      return [];
    }
  }

  // Fetch a single citation by ID
  Future<Citation?> getCitationById(String id) async {
    try {
      final DocumentSnapshot doc = await _firestore
          .collection(collectionPath)
          .doc(id)
          .get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Citation(
          id: doc.id,
          mood: data['mood'],
          text: Map<String, String>.from(data['text']),
        );
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching citation by id: $e');
      }
      return null;
    }
  }

  // Add a new citation
  Future<String?> addCitation(Citation citation) async {
    try {
      final DocumentReference doc = await _firestore
          .collection(collectionPath)
          .add(citation.toFirestore());
      return doc.id;
    } catch (e) {
      if (kDebugMode) {
        print('Error adding citation: $e');
      }
      return null;
    }
  }

  // Update an existing citation
  Future<bool> updateCitation(Citation citation) async {
    try {
      await _firestore
          .collection(collectionPath)
          .doc(citation.id)
          .update(citation.toFirestore());
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error updating citation: $e');
      }
      return false;
    }
  }

  // Delete a citation
  Future<bool> deleteCitation(String id) async {
    try {
      await _firestore.collection(collectionPath).doc(id).delete();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting citation: $e');
      }
      return false;
    }
  }
}

extension CitationLocalization on Citation {
  /// Retourne le texte localisé en se basant sur :
  /// 1) la liste `preferred` si fournie,
  /// 2) le locale de l'app (locale.toLanguageTag(), locale.languageCode),
  /// 3) les fallbacks 'en','fr','es',
  /// 4) enfin la première valeur disponible.
  String textForLocale(BuildContext context, {List<String>? preferred}) {
    final locale = Localizations.localeOf(context);
    final codes = <String>[];

    if (preferred != null && preferred.isNotEmpty) {
      codes.addAll(preferred);
    }

    // ajouter variantes de locale
    if (locale.toLanguageTag().isNotEmpty) {
      codes.add(locale.toLanguageTag()); // ex: en-US
    }
    if (locale.languageCode.isNotEmpty) {
      codes.add(locale.languageCode); // ex: en
    }
    if (locale.countryCode != null && locale.countryCode!.isNotEmpty) {
      codes.add('${locale.languageCode}-${locale.countryCode}');
    }

    // fallbacks communs
    codes.addAll(['en', 'fr', 'es']);

    // supprimer doublons en conservant l'ordre
    final seen = <String>{};
    final ordered = codes.where((c) => c.isNotEmpty && seen.add(c)).toList();

    for (final code in ordered) {
      // correspondance exacte
      if (text.containsKey(code)) return text[code]!;
      // essayer la base si code contient '-'
      final base = code.split('-').first;
      if (text.containsKey(base)) return text[base]!;
    }

    // dernier recours : première valeur
    if (text.isNotEmpty) return text.values.first;
    return '';
  }

  /// Accès direct par code langue (avec fallback sur base / 'en' / première)
  String textForLang(String langCode) {
    if (text.containsKey(langCode)) return text[langCode]!;
    final base = langCode.split('-').first;
    if (text.containsKey(base)) return text[base]!;
    if (text.containsKey('en')) return text['en']!;
    if (text.isNotEmpty) return text.values.first;
    return '';
  }
}
