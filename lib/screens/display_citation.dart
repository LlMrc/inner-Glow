import 'package:flutter/material.dart';
import 'package:nodus_application/l10n/app_localizations.dart';
import 'package:nodus_application/local/database_helper.dart';
import 'package:nodus_application/models/citation_model.dart';
import 'package:nodus_application/services/google_ads_heleper.dart';
import 'package:nodus_application/services/screenshot_service.dart';
import 'package:nodus_application/services/share_service.dart';
import 'package:nodus_application/widgets/citation_view.dart';
import 'package:nodus_application/widgets/editors/font_picker.dart';
import 'package:nodus_application/widgets/editors/gradient_picker.dart';

import 'package:screenshot/screenshot.dart';

class DisplayCitation extends StatefulWidget {
  const DisplayCitation({super.key, this.mood, this.citationText});

  final String? mood;
  final String? citationText;
  @override
  State<DisplayCitation> createState() => _DisplayCitationState();
}

class _DisplayCitationState extends State<DisplayCitation> {
  // Ajouter une variable d'état pour la citation actuelle
  Citation? currentCitation;
  // Services
  final ScreenshotService _screenshotService = ScreenshotService();
  final ShareService _shareService = ShareService();

  // Utilisez le controller du service
  get screenshotController => _screenshotService.controller;

  Future<void> _captureAndShare() async {
    final imageFile = await _screenshotService.captureAndSave();
    if (imageFile != null) {
      await _shareService.shareImage(imageFile);
    }
  }

  // Liste de gradients disponibles
  final List<Gradient> gradients = [
    LinearGradient(colors: [Colors.blue, Colors.purple]),
    LinearGradient(colors: [Colors.orange, Colors.red]),
    LinearGradient(colors: [Colors.green, Colors.teal]),
    LinearGradient(colors: [Colors.yellow, Colors.black45]),
    LinearGradient(colors: [Colors.pink, Colors.grey]),
    LinearGradient(colors: [Colors.tealAccent, Colors.blue]),
    LinearGradient(colors: [Colors.indigo, Colors.brown]),
  ];

  // Liste d'images de background disponibles (ajoutez ces fichiers dans pubspec.yaml)
  final List<String> backgroundImages = [
    '',
    'assets/images/bg1.jpeg',
    'assets/images/bg2.jpeg',
    'assets/images/bg3.jpeg',
    'assets/images/bg4.jpeg',
    'assets/images/bg5.jpeg',
    'assets/images/bg6.jpeg',
    'assets/images/bg7.jpeg',
    'assets/images/bg8.jpeg',
    'assets/images/bg9.jpeg',
    'assets/images/bg10.jpeg',
    'assets/images/bg11.jpeg',
    'assets/images/bg12.jpeg',
    'assets/images/bg13.jpeg',
    'assets/images/bg15.jpeg',
    'assets/images/bg16.jpeg',
    'assets/images/bg17.jpeg',
    'assets/images/bg18.jpeg',
    'assets/images/bg19.jpeg',
    'assets/images/bg20.jpeg',
    'assets/images/bg21.jpeg',
  ];

  // Liste des familles de polices disponibles (défaut si aucune police personnalisée n'est fournie)
  final List<String> fontFamilies = [
    'Quicksand',
    'Open Sans',
    'Karla-MediumItalic',
    'MomoSignature',
    'ShadowsIntoLight-Regular',
  ];

  int currentIndex = 0;
  int selectedIndex = 0;

  // indices pour background et font
  int selectedBackgroundIndex = 0;
  int selectedFontIndex = 0;

  bool isShare = false;

  void changeGradient() {
    setState(() {
      currentIndex = (currentIndex + 1) % gradients.length;
    });
  }

  final GoogleAdsHelper _adsHelper = GoogleAdsHelper();

  @override
  void initState() {
    _adsHelper.loadInterstitialAd();

    super.initState();
  }

  final citationHelper = CitationHelper();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      extendBody: true,
      body: Screenshot(
        controller: screenshotController,
        child: (widget.mood) != null
            ? FutureBuilder<List<Citation>>(
                future: citationHelper.getCitationsByMood(
                  widget.mood!.toLowerCase(),
                ),
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (asyncSnapshot.hasError) {
                    return Center(child: Text('Error: ${asyncSnapshot.error}'));
                  } else {
                    final citations = asyncSnapshot.data as List<Citation>;
                    if (citations.isEmpty) {
                      return Center(child: Text('No citations found.'));
                    }
                    // Initialiser la citation courante si pas encore fait
                    if (currentCitation == null) {
                      if (asyncSnapshot.hasData) {
                        if (currentCitation == null && asyncSnapshot.hasData) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _shuffleCitation(citations);
                          });
                        }
                      }
                    }
                    // Vérifier si on a une citation
                    if (currentCitation == null) {
                      return Center(child: Text('No citation available.'));
                    }

                    return Stack(
                      alignment: AlignmentGeometry.bottomCenter,
                      children: [
                        widget.citationText == null
                            ? CitationView(
                                text: currentCitation!.textForLocale(context),
                                fontFamily: fontFamilies[selectedFontIndex],
                                gradient: gradients[currentIndex],
                                backgroundImage:
                                    backgroundImages[selectedBackgroundIndex],
                              )
                            : CitationView(
                                text: widget.citationText!,
                                fontFamily: fontFamilies[selectedFontIndex],
                                gradient: gradients[currentIndex],
                                backgroundImage:
                                    backgroundImages[selectedBackgroundIndex],
                              ),

                        Positioned(
                          bottom: 100,
                          child: !isShare
                              ? IconButton(
                                  onPressed: () {
                                    if (asyncSnapshot.hasData) {
                                      _shuffleCitation(asyncSnapshot.data!);
                                    }
                                  },
                                  icon: Icon(
                                    Icons.refresh,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                )
                              : SizedBox.shrink(),
                        ),

                        // Boutons d'édition (hors capture)
                        (isShare == false)
                            ? Positioned(
                                bottom: 10,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    _buildEditor(
                                      icon: Icon(
                                        Icons.color_lens,
                                        color: Colors.grey.shade200,
                                        size: 34,
                                      ),
                                      text: l10n!.gradientEditor,
                                      onTap: () => setState(() {
                                        selectedBackgroundIndex = 0;
                                        selectedIndex = 0;
                                      }),
                                    ),
                                    _buildEditor(
                                      icon: Icon(
                                        Icons.font_download,
                                        color: Colors.grey.shade200,
                                        size: 34,
                                      ),
                                      text: l10n.fontEditor,
                                      onTap: () =>
                                          setState(() => selectedIndex = 1),
                                    ),
                                    _buildEditor(
                                      icon: Icon(
                                        Icons.image,
                                        color: Colors.grey.shade200,
                                        size: 34,
                                      ),
                                      text: l10n.backgroundEditor,
                                      onTap: () =>
                                          setState(() => selectedIndex = 2),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox.shrink(),
                        Positioned(
                          top: 60,
                          right: 10,
                          child: _saveButton(context),
                        ),
                      ],
                    );
                  }
                },
              )
            : Stack(
                alignment: AlignmentGeometry.bottomCenter,
                children: [
                  widget.citationText == null
                      ? CitationView(
                          text: currentCitation!.textForLocale(context),
                          fontFamily: fontFamilies[selectedFontIndex],
                          gradient: gradients[currentIndex],
                          backgroundImage:
                              backgroundImages[selectedBackgroundIndex],
                        )
                      : CitationView(
                          text: widget.citationText!,
                          fontFamily: fontFamilies[selectedFontIndex],
                          gradient: gradients[currentIndex],
                          backgroundImage:
                              backgroundImages[selectedBackgroundIndex],
                        ),

                  // Boutons d'édition (hors capture)
                  (isShare == false)
                      ? Positioned(
                          bottom: 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _buildEditor(
                                icon: Icon(
                                  Icons.color_lens,
                                  color: Colors.grey.shade200,
                                  size: 34,
                                ),
                                text: l10n!.gradientEditor,
                                onTap: () => setState(() {
                                  selectedBackgroundIndex = 0;
                                  selectedIndex = 0;
                                }),
                              ),
                              _buildEditor(
                                icon: Icon(
                                  Icons.font_download,
                                  color: Colors.grey.shade200,
                                  size: 34,
                                ),
                                text: l10n.fontEditor,
                                onTap: () => setState(() => selectedIndex = 1),
                              ),
                              _buildEditor(
                                icon: Icon(
                                  Icons.image,
                                  color: Colors.grey.shade200,
                                  size: 34,
                                ),
                                text: l10n.backgroundEditor,
                                onTap: () => setState(() => selectedIndex = 2),
                              ),
                            ],
                          ),
                        )
                      : SizedBox.shrink(),
                  Positioned(top: 60, right: 10, child: _saveButton(context)),
                ],
              ),
      ),
      bottomSheet: _widgetForCurrentIndex(),
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

  Widget _widgetForCurrentIndex() {
    switch (selectedIndex) {
      case 0:
        return GradientPicker(
          gradients: gradients,
          selectedIndex: currentIndex,
          onGradientSelected: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        );
      case 1:
        return FontPicker(
          fonts: fontFamilies,
          selectedIndex: selectedFontIndex,
          onFontSelected: (index) {
            setState(() {
              selectedFontIndex = index;
            });
          },
        );
      case 2:
        return _showBackgroundPicker();
      default:
        return SizedBox.shrink();
    }
  }

  _buildEditor({
    required String text,
    required Icon icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
              ),
              child: icon,
            ),
            Text(text, style: TextStyle(color: Colors.grey.shade100)),
          ],
        ),
      ),
    );
  }

  final bool _isPremiumUser = false;

  Widget _showBackgroundPicker() {
    return Container(
      padding: EdgeInsets.all(16),
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: backgroundImages.length,
        separatorBuilder: (_, __) => SizedBox(width: 12),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => setState(() {
              selectedBackgroundIndex = index;
            }),
            // onTap: _isPremiumUser
            //     ? () {
            //         setState(() {
            //           selectedBackgroundIndex = index;
            //         });
            //       }
            //     : null,
            child: Stack(
              children: [
                Container(
                  width: 80,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: selectedBackgroundIndex == index
                          ? Colors.black
                          : Colors.white,
                      width: 2,
                    ),
                    image: DecorationImage(
                      image: AssetImage(backgroundImages[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (!_isPremiumUser)
                  Container(
                    width: 80,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(child: Icon(Icons.lock, color: Colors.white)),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  final saveRecentCitation = StringListDatabaseHelper();

  Widget _saveButton(context) {
    return !isShare
        ? Column(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () async {
                  if (currentCitation != null) {
                    saveRecentCitation.add(
                      currentCitation!.textForLocale(context),
                    );
                  }
                  Future.delayed(Durations.medium1, () {
                    _adsHelper.showInterstitialAd();
                  });
                },
                child: Text(
                  // AppLocalizations.of(context)!.saveText,
                  'Save',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    shadows: [Shadow(blurRadius: 2, color: Colors.black26)],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isShare = true;
                  });

                  Future.delayed(Duration(milliseconds: 2), () {
                    setState(() {
                      isShare = false;
                    });
                  });
                  if (currentCitation != null) {
                    saveRecentCitation.add(
                      currentCitation!.textForLocale(context),
                    );
                  }
                  Future.delayed(Durations.medium1, () {
                    _adsHelper.showInterstitialAd();
                  });
                },
                child: GestureDetector(
                  onTap: () {
                    if (currentCitation != null) {
                      _shareService.shareText(
                        currentCitation!.textForLocale(context),
                      );
                      saveRecentCitation.add(
                        currentCitation!.textForLocale(context),
                      );
                    }
                    Future.delayed(Durations.medium1, () {
                      _adsHelper.showInterstitialAd();
                    });
                  },
                  child: Text(
                    AppLocalizations.of(context)!.shareText,
                    style: TextStyle(
                      fontSize: 20,
                      color: const Color.fromRGBO(255, 255, 255, 1),
                      shadows: [Shadow(blurRadius: 2, color: Colors.black26)],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (currentCitation != null) {
                    saveRecentCitation.add(
                      currentCitation!.textForLocale(context),
                    );
                  }
                  setState(() {
                    isShare = true;
                  });

                  Future.delayed(Duration(milliseconds: 500), () {
                    _captureAndShare();
                  });

                  Future.delayed(Duration(seconds: 2), () {
                    setState(() {
                      isShare = false;
                    });
                  });
                },
                child: Text(
                  AppLocalizations.of(context)!.shareImage,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    shadows: [Shadow(blurRadius: 2, color: Colors.black26)],
                  ),
                ),
              ),
            ],
          )
        : SizedBox.shrink();
  }
}
// ...existing code...
// supposons que `citation` est une instance de Citation récupérée
// final displayedText = citation.textForLocale(context);

// // Puis dans le widget:
// Text(
//   displayedText,
//   textAlign: TextAlign.center,
//   style: TextStyle(
//     fontFamily: fontFamilies[selectedFontIndex].isEmpty ? null : fontFamilies[selectedFontIndex],
//     fontSize: 28,
//     color: Colors.white,
//   ),
// ),
