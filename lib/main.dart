import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nodus_application/models/citation_model.dart';
import 'package:nodus_application/screens/home.dart';
import 'package:nodus_application/l10n/app_localizations.dart';
import 'package:nodus_application/local/database_helper.dart';
import 'package:nodus_application/screens/display_citation.dart';
import 'package:nodus_application/utils/theme_notifier.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  StringListDatabaseHelper().init();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (BuildContext context, ThemeProvider value, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Glow',
          theme: value.getTheme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Home(),
        );
      },
      // child: MaterialApp(
      //   title: 'Glow',
      //   theme: ThemeData(
      //     colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   ),
      //   localizationsDelegates: AppLocalizations.localizationsDelegates,
      //   supportedLocales: AppLocalizations.supportedLocales,
      //   home: Home(),
      // ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final favoriteCitationList = StringListDatabaseHelper.instance;

  final citationHelper = CitationHelper();
  Citation? currentCitation;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.wb_sunny_rounded),
        title: Text(l10n!.appTitle),
        actions: [
          _premiumIcon(
            onTap: () {
              print('Premium Tapped');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  l10n.howAreYouToday,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              SizedBox(height: 40),
              Wrap(
                spacing: 30,
                children: [
                  _buildGlowContainer(
                    child: '😊',
                    glowColor: Colors.yellowAccent,
                    data: l10n.happy,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DisplayCitation(mood: 'happy'),
                      ),
                    ),
                  ),
                  _buildGlowContainer(
                    child: '😔',
                    glowColor: Colors.blueAccent,
                    data: l10n.sad,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DisplayCitation(mood: 'sad'),
                      ),
                    ),
                  ),
                  _buildGlowContainer(
                    child: '😡',
                    glowColor: Colors.redAccent,
                    data: l10n.angry,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DisplayCitation(mood: 'angry'),
                      ),
                    ),
                  ),
                  _buildGlowContainer(
                    child: '😱',
                    glowColor: Colors.purpleAccent,
                    data: l10n.scared,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DisplayCitation(mood: 'scared'),
                      ),
                    ),
                  ),
                  _buildGlowContainer(
                    child: '😴',
                    glowColor: Colors.greenAccent,
                    data: l10n.tired,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DisplayCitation(mood: 'tired'),
                      ),
                    ),
                  ),
                  _buildGlowContainer(
                    child: '🤢',
                    glowColor: Colors.green,
                    data: l10n.sick,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DisplayCitation(mood: 'sick'),
                      ),
                    ),
                  ),
                  _buildGlowContainer(
                    child: '😍',
                    glowColor: Colors.pinkAccent,
                    data: l10n.inLove,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DisplayCitation(mood: 'inLove'),
                      ),
                    ),
                  ),
                  _buildGlowContainer(
                    child: '🤯',
                    glowColor: Colors.orangeAccent,
                    data: l10n.stressed,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DisplayCitation(mood: 'stressed'),
                      ),
                    ),
                  ),
                  _buildGlowContainer(
                    child: '😌',
                    glowColor: Colors.blueGrey,
                    data: l10n.calm,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DisplayCitation(mood: 'calm'),
                      ),
                    ),
                  ),
                  _buildGlowContainer(
                    child: '💡',
                    glowColor: Colors.deepPurpleAccent,
                    data: l10n.inspired,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DisplayCitation(mood: 'inspired'),
                      ),
                    ),
                  ),
                  _buildGlowContainer(
                    child: '💪',
                    glowColor: Colors.tealAccent,
                    data: l10n.motivated,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            DisplayCitation(mood: 'motivated'),
                      ),
                    ),
                  ),
                  _buildGlowContainer(
                    child: '🤔',
                    glowColor: Colors.deepOrange,
                    data: l10n.thoughtful,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            DisplayCitation(mood: 'thoughtful'),
                      ),
                    ),
                  ),
                ],
              ),

              // Add your localization strings here
              // Example of localization strings in ARB format
              SizedBox(height: 40),

              Container(
                padding: EdgeInsets.all(16),

                height: 230,
                margin: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.purple.shade200,
                      Colors.blueAccent.shade100,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l10n.quoteOfTheDay),
                    SizedBox(height: 8),
                    FutureBuilder(
                      future: citationHelper.getCitationsByMood('dailyQuote'),
                      builder: (context, asyncSnapshot) {
                        if (asyncSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (asyncSnapshot.hasError) {
                          return Center(
                            child: Text('Error: ${asyncSnapshot.error}'),
                          );
                        } else {
                          final citations =
                              asyncSnapshot.data as List<Citation>;
                          if (citations.isEmpty) {
                            return Center(child: Text('No citations found.'));
                          }
                          // Initialiser la citation courante si pas encore fait
                          if (currentCitation == null) {
                            if (asyncSnapshot.hasData) {
                              if (currentCitation == null &&
                                  asyncSnapshot.hasData) {
                                WidgetsBinding.instance.addPostFrameCallback((
                                  _,
                                ) {
                                  _shuffleCitation(citations);
                                  print('citation length: ${citations.length}');
                                });
                              }
                            }
                          }
                          // Vérifier si on a une citation
                          if (currentCitation == null) {
                            return Center(
                              child: Text('No citation available.'),
                            );
                          }

                          return Text(
                            currentCitation!.textForLocale(context),

                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 24,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w800,
                            ),
                            textAlign: TextAlign.center,
                          );
                        }
                      },
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          style: TextButton.styleFrom(
                            shadowColor: Colors.transparent,
                            backgroundColor: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    DisplayCitation(mood: l10n.dailyQuote),
                              ),
                            );
                          },
                          label: Text(l10n.share),
                          icon: Icon(Icons.share),
                        ),
                        Spacer(),
                        TextButton.icon(
                          style: TextButton.styleFrom(
                            shadowColor: Colors.transparent,
                            backgroundColor: Colors.white,
                          ),
                          onPressed: () {
                            favoriteCitationList.add(l10n.dailyQuote);
                            setState(() => _isFavorite = true);
                          },
                          label: Text(l10n.addToFavorites),
                          icon: _isFavorite == true
                              ? Icon(Icons.favorite, color: Colors.red)
                              : Icon(Icons.favorite_border),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  bool _isFavorite = false;
  Widget _premiumIcon({required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: EdgeInsets.symmetric(horizontal: 12),
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          border: Border.all(
            color: Color(0xFFFFD700), // Gold color
            width: 2,
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Premium',
              style: TextStyle(
                color: Color(0xFFFFD700), // Gold text
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.star, color: Colors.amber, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildGlowContainer({
    required String child,
    required Color glowColor,
    required String data,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        SizedBox(height: 18),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(8),
            alignment: Alignment.center,
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: glowColor,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              child,
              style: TextStyle(fontSize: 40),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(data),
      ],
    );
  }

  // Méthode pour choisir une citation aléatoire
  void _shuffleCitation(List<Citation> citations) {
    if (citations.isNotEmpty) {
      setState(() {
        citations.shuffle();
        currentCitation = citations.first;
      });
    }
  }
}
