import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RateUsWidget extends StatefulWidget {
  const RateUsWidget({super.key});

  @override
  _RateUsWidgetState createState() => _RateUsWidgetState();
}

class _RateUsWidgetState extends State<RateUsWidget> {
  final Uri _url = Uri.parse(
    'https://play.google.com/store/apps/details?id=com.innerglow.gravitylab',
  );

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  int _rating = 0;

  void _submitRating() {
    // Handle rating submission logic here
    _launchUrl();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Thanks for rating us $_rating stars!')),
    );
  }

  Widget _buildStar(int index) {
    return IconButton(
      icon: Icon(
        index <= _rating ? Icons.star : Icons.star_border,
        color: Colors.amber,
      ),
      onPressed: () {
        setState(() {
          _rating = index;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Rate Us', style: TextStyle(fontSize: 24)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) => _buildStar(index + 1)),
        ),
        ElevatedButton(
          onPressed: _rating == 0 ? null : _submitRating,
          child: Text('Submit'),
        ),
      ],
    );
  }
}
