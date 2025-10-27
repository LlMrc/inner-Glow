import 'package:flutter/material.dart';

class GradientPicker extends StatelessWidget {
  final List<Gradient> gradients;
  final int selectedIndex;
  final Function(int) onGradientSelected;

  const GradientPicker({
    super.key,
    required this.gradients,
    required this.selectedIndex,
    required this.onGradientSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: gradients.length,
        separatorBuilder: (_, __) => SizedBox(width: 12),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => onGradientSelected(index),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: gradients[index],
                border: Border.all(
                  color: selectedIndex == index ? Colors.black : Colors.white,
                  width: 3,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
