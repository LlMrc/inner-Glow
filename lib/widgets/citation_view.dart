import 'package:flutter/material.dart';

class CitationView extends StatelessWidget {
  final String text;
  final String fontFamily;
  final Gradient gradient;
  final String backgroundImage;

  const CitationView({
    super.key,
    required this.text,
    required this.fontFamily,
    required this.gradient,
    required this.backgroundImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
        ],
        gradient: gradient,
        image: backgroundImage.isNotEmpty
            ? DecorationImage(
                image: AssetImage(backgroundImage),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: fontFamily.isEmpty ? null : fontFamily,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [Shadow(blurRadius: 2, color: Colors.black26)],
          ),
        ),
      ),
    );
  }
}
