import 'package:flutter/material.dart';
import 'package:nodus_application/l10n/app_localizations.dart';
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
  ];

  // Liste d'images de background disponibles (ajoutez ces fichiers dans pubspec.yaml)
  final List<String> backgroundImages = [
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
    'Roboto',
    'Georgia',
    'Times New Roman',
    'Arial',
  ];

  int currentIndex = 0;
  int selectedIndex = 0;

  // indices pour background et font
  int selectedBackgroundIndex = 2;
  int selectedFontIndex = 0;

  bool isBottomSheetVisible = true;
  bool isSaveButtonVisible = true;

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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final citationHelper = CitationHelper();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // Partie à capturer
          Expanded(
            child: Screenshot(
              controller: screenshotController,
              child: FutureBuilder(
                future: citationHelper.getCitationsByMood(
                  widget.mood ?? l10n!.calm,
                ),
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (asyncSnapshot.hasError) {
                    return Center(child: Text('Error: ${asyncSnapshot.error}'));
                  } else {
                    final citations = asyncSnapshot.data as List<String>;
                    if (citations.isEmpty) {
                      return Center(child: Text('No citations found.'));
                    }
                    // Initialiser la citation courante si pas encore fait
                    if (currentCitation == null) {
                      _shuffleCitation(asyncSnapshot.data!);
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
                          bottom: 20,
                          child: _showRefreshBtn
                              ? IconButton(
                                  onPressed: () {
                                    if (asyncSnapshot.hasData) {
                                      _shuffleCitation(asyncSnapshot.data!);
                                    }
                                  },
                                  icon: Icon(Icons.refresh),
                                )
                              : SizedBox.shrink(),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),

          // Boutons d'édition (hors capture)
          if (isSaveButtonVisible)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildEditor(
                  icon: Icon(Icons.color_lens),
                  text: l10n!.gradientEditor,
                  onTap: () => setState(() => selectedIndex = 0),
                ),
                _buildEditor(
                  icon: Icon(Icons.font_download),
                  text: l10n.fontEditor,
                  onTap: () => setState(() => selectedIndex = 1),
                ),
                _buildEditor(
                  icon: Icon(Icons.image),
                  text: l10n.backgroundEditor,
                  onTap: () => setState(() => selectedIndex = 2),
                ),
              ],
            ),
        ],
      ),
      bottomSheet: isBottomSheetVisible
          ? Row(
              children: [
                Expanded(child: _widgetForCurrentIndex()),
                SizedBox(width: 20),
                _saveButton(
                  onTap: () => setState(() {
                    isBottomSheetVisible = false;
                    isSaveButtonVisible = false;
                    _adsHelper.showInterstitialAd();
                  }),
                ),
              ],
            )
          : shareButton(),
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

  Widget shareButton() {
    final l10n = AppLocalizations.of(context);
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: Row(
        children: [
          TextButton.icon(
            style: TextButton.styleFrom(
              shadowColor: Colors.transparent,
              backgroundColor: Colors.white,
            ),
            onPressed: () {
              setState(() => _showRefreshBtn = false);
              if (currentCitation != null) {
                _shareService.shareText(
                  currentCitation!.textForLocale(context),
                );
              }
            },
            label: Text(l10n!.shareText),
            icon: Icon(Icons.font_download),
          ),
          // ...existing code...
          TextButton.icon(
            style: TextButton.styleFrom(
              shadowColor: Colors.transparent,
              backgroundColor: Colors.white,
            ),
            onPressed: () {
              _captureAndShare();
            },
            label: Text(l10n.shareImage),
            icon: Icon(Icons.image_outlined),
          ),
        ],
      ),
    );
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
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
              ),
              child: icon,
            ),
            Text(text),
          ],
        ),
      ),
    );
  }

  final bool _isPremiumUser = false;

  bool _showRefreshBtn =
      true; // Remplacez par la logique réelle de vérification de l'utilisateur premium

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
            onTap: _isPremiumUser
                ? () {
                    setState(() {
                      selectedBackgroundIndex = index;
                    });
                  }
                : null,
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
                      color: Colors.black54,
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

  Widget _saveButton({required VoidCallback onTap}) {
    return isSaveButtonVisible
        ? IconButton(onPressed: onTap, icon: Icon(Icons.save))
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
