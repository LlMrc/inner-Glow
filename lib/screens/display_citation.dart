// ...existing code...
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class DisplayCitation extends StatefulWidget {
  const DisplayCitation({super.key, required this.id});

  final String id;
  @override
  State<DisplayCitation> createState() => _DisplayCitationState();
}

class _DisplayCitationState extends State<DisplayCitation> {
  // Ajouter le controller pour screenshot
  final screenshotController = ScreenshotController();

  Future<void> _captureAndShare() async {
    final image = await screenshotController.capture();
    if (image == null) return;

    final directory = await getTemporaryDirectory();
    final imagePath = '${directory.path}/citation.png';
    final imageFile = File(imagePath);
    await imageFile.writeAsBytes(image);

    await Share.shareXFiles([
      XFile(imagePath),
    ], text: 'Ma citation personnalisée');
  }

  // Liste de gradients disponibles
  final List<Gradient> gradients = [
    LinearGradient(colors: [Colors.blue, Colors.purple]),
    LinearGradient(colors: [Colors.orange, Colors.red]),
    LinearGradient(colors: [Colors.green, Colors.teal]),
  ];

  // Liste d'images de background disponibles (ajoutez ces fichiers dans pubspec.yaml)
  final List<String> backgroundImages = [
    'assets/images/bg1.png',
    'assets/images/bg2.png',
    'assets/images/citation_background.png',
  ];

  // Liste de familles de polices (utiliser des polices système ou celles ajoutées au projet)
  final List<String> fontFamilies = [
    '', // default system font
    'Courier',
    'Georgia',
    'Times New Roman',
  ];

  int currentIndex = 0;
  int selectedIndex = 0;

  // indices pour background et font
  int selectedBackgroundIndex = 2;
  int selectedFontIndex = 0;

  bool isBottomSheetVisible = true;
  bool isSaveButtonVisible = false;

  void changeGradient() {
    setState(() {
      currentIndex = (currentIndex + 1) % gradients.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final sampleText = 'Voici une citation exemple';

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // Partie à capturer
          Expanded(
            child: Screenshot(
              controller: screenshotController,
              child: AnimatedContainer(
                duration: Duration(seconds: 1),
                curve: Curves.easeInOut,
                width: size.width,
                height: size.height,
                decoration: BoxDecoration(
                  gradient: gradients[currentIndex],
                  image: DecorationImage(
                    image: AssetImage(
                      backgroundImages[selectedBackgroundIndex],
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        sampleText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: fontFamilies[selectedFontIndex].isEmpty
                              ? null
                              : fontFamilies[selectedFontIndex],
                          fontSize: 28,
                          color: Colors.white,
                          shadows: [
                            Shadow(blurRadius: 2, color: Colors.black26),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Boutons d'édition (hors capture)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildEditor(
                icon: Icon(Icons.color_lens),
                text: 'couleur',
                onTap: () {
                  setState(() {
                    selectedIndex = 0;
                  });
                },
              ),
              _buildEditor(
                icon: Icon(Icons.font_download),
                text: 'police',
                onTap: () {
                  setState(() {
                    selectedIndex = 1;
                  });
                },
              ),
              _buildEditor(
                icon: Icon(Icons.image),
                text: 'background',
                onTap: () {
                  setState(() {
                    selectedIndex = 2;
                  });
                },
              ),
            ],
          ),
        ],
      ),
      bottomSheet: isBottomSheetVisible
          ? Row(
              children: [
                _widgetForCurrentIndex(),
                SizedBox(width: 20),
                _saveButton(
                  onTap: () {
                    setState(() {
                      isBottomSheetVisible = false;
                      isSaveButtonVisible = false;
                    });
                  },
                ),
              ],
            )
          : shareButton(),
    );
  }

  Widget shareButton() {
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
              // Partager le texte seul
              SharePlus.instance.share(
                ShareParams(text: 'Voici une citation exemple'),
              );
            },
            label: Text('Partager text'),
            icon: Icon(Icons.font_download),
          ),
          Spacer(),
          TextButton.icon(
            style: TextButton.styleFrom(
              shadowColor: Colors.transparent,
              backgroundColor: Colors.white,
            ),
            onPressed: _captureAndShare,
            label: Text('Partager image'),
            icon: Icon(Icons.image_outlined),
          ),
        ],
      ),
    );
  }

  Widget _widgetForCurrentIndex() {
    switch (selectedIndex) {
      case 0:
        return _showGradientPicker();
      case 1:
        return _showFrontPicker(); // ici c'est le picker de polices
      case 2:
        return _showBackgroundPicker();
      default:
        return SizedBox.shrink();
    }
  }

  Widget _showGradientPicker() {
    return Container(
      padding: EdgeInsets.all(16),
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: gradients.length,
        separatorBuilder: (_, __) => SizedBox(width: 12),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                currentIndex = index;
              });
              // ne pas pop - on reste dans le bottom sheet
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: gradients[index],
                border: Border.all(
                  color: currentIndex == index ? Colors.black : Colors.white,
                  width: 3,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _showFrontPicker() {
    return Container(
      padding: EdgeInsets.all(16),
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: fontFamilies.length,
        separatorBuilder: (_, __) => SizedBox(width: 12),
        itemBuilder: (context, index) {
          final family = fontFamilies[index];
          return GestureDetector(
            onTap: _isPremiumUser
                ? () {
                    setState(() {
                      selectedFontIndex = index;
                    });
                  }
                : null,
            child: Stack(
              children: [
                Container(
                  width: 80,
                  height: 60,
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: selectedFontIndex == index
                          ? Colors.black
                          : Colors.white,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Aa',
                      style: TextStyle(
                        fontFamily: family.isEmpty ? null : family,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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

  final bool _isPremiumUser =
      false; // Remplacez par la logique réelle de vérification de l'utilisateur premium

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