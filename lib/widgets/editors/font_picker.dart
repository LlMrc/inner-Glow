import 'package:flutter/material.dart';

class FontPicker extends StatelessWidget {
  final List<String> fonts;
  final int selectedIndex;
  final Function(int) onFontSelected;

  const FontPicker({
    super.key,
    required this.fonts,
    required this.selectedIndex,
    required this.onFontSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,

      padding: EdgeInsets.all(16),
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: fonts.length,
        separatorBuilder: (_, __) => SizedBox(width: 12),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => onFontSelected(index),
            child: Center(
              child: Container(
                width: 50,
                height: 50,
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: selectedIndex == index
                        ? Colors.grey.shade200
                        : Colors.white,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    'Aa',
                    style: TextStyle(
                      fontFamily: fonts[index].isEmpty ? null : fonts[index],
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
