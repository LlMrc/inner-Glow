import 'package:flutter/material.dart';
import 'package:nodus_application/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Glow',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Home(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.wb_sunny_rounded),
        title: Text('inner Glow'),
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
                  'Comment vous sentez vous aujourd\'hui ?✨',
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
                    data: 'Heureux',
                  ),

                  _buildGlowContainer(
                    child: '😔',
                    glowColor: Colors.blueAccent,
                    data: 'Triste',
                  ),

                  _buildGlowContainer(
                    child: '😡',
                    glowColor: Colors.redAccent,
                    data: 'En colère',
                  ),
                  _buildGlowContainer(
                    child: '😱',
                    glowColor: Colors.purpleAccent,
                    data: 'Effrayé',
                  ),
                  _buildGlowContainer(
                    child: '😴',
                    glowColor: Colors.greenAccent,
                    data: 'Fatigué',
                  ),
                  _buildGlowContainer(
                    child: '🤢',
                    glowColor: Colors.green,
                    data: 'Malade',
                  ),
                  _buildGlowContainer(
                    child: '😍',
                    glowColor: Colors.pinkAccent,
                    data: 'Amoureux',
                  ),
                  _buildGlowContainer(
                    child: '🤯',
                    glowColor: Colors.orangeAccent,
                    data: 'Stressé',
                  ),
                  _buildGlowContainer(
                    child: '😌',
                    glowColor: Colors.blueGrey,
                    data: 'Calme',
                  ),

                  _buildGlowContainer(
                    child: '💡',
                    glowColor: Colors.deepPurpleAccent,
                    data: 'Inspiré',
                  ),
                  _buildGlowContainer(
                    child: '💪',
                    glowColor: Colors.tealAccent,
                    data: 'Motivé',
                  ),
                  _buildGlowContainer(
                    child: '🤔',
                    glowColor: Colors.deepOrange,
                    data: 'Pensif',
                  ),
                ],
              ),

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
                    Text('Citation du jour'),
                    SizedBox(height: 8),
                    Text(
                      'La vie est belle, profitez de chaque instant.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 24,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
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
                            print('partager');
                          },
                          label: Text('Partager'),
                          icon: Icon(Icons.share),
                        ),
                        Spacer(),
                        TextButton.icon(
                          style: TextButton.styleFrom(
                            shadowColor: Colors.transparent,
                            backgroundColor: Colors.white,
                          ),
                          onPressed: () {
                            print('Ajouter aux favoris');
                          },
                          label: Text('Ajouter aux favoris'),
                          icon: Icon(Icons.favorite_border),
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
              color: Colors.black.withValues(alpha: 0.2),
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
  }) {
    return Column(
      children: [
        SizedBox(height: 18),
        Container(
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
        SizedBox(height: 8),
        Text(data),
      ],
    );
  }
}
