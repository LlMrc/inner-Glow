import 'package:flutter/material.dart';

import 'package:nodus_application/local/database_helper.dart';
import 'package:nodus_application/screens/display_citation.dart';
import 'package:nodus_application/services/google_ads_heleper.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  final favoriteCitationList = StringListDatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorite Citations')),
      body: FutureBuilder(
        future: favoriteCitationList.getFavoriteCitationList(),
        builder: (context, asyncSnapshot) {
          final citations = asyncSnapshot.data;
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator.adaptive();
          }
          if (!asyncSnapshot.hasData || asyncSnapshot.hasError) {
            return Center(
              child: Text(
                'No data found.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }
          if (citations == null || citations.isEmpty) {
            return Center(
              child: Text(
                'No favorite citations available.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }
          final setCitation = citations.toSet().toList();
          final maxItems = setCitation.length > 10 ? 10 : setCitation.length;
          return ListView.builder(
            itemCount: maxItems + (maxItems ~/ 4), // Add extra slots for ads
            itemBuilder: (context, index) {
              // Calculate the actual index in the citations list
              final itemIndex = index - (index ~/ 5);

              // Insert banner ad after every 4 items
              if ((index + 1) % 5 == 0) {
                return BannerAdWidget();
              }

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 10,
                ),
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                    gradient: LinearGradient(
                      colors: [Colors.deepPurple.shade50, Colors.pink.shade100],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lightbulb_outline_rounded, size: 16),
                      SizedBox(height: 8),
                      Text(
                        setCitation[itemIndex],
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DisplayCitation(
                                    citationText: setCitation[itemIndex],
                                  ),
                                ),
                              );
                            },
                            child: Text('Edit'),
                          ),
                          SizedBox(width: 8),
                          TextButton(
                            onPressed: () {
                              favoriteCitationList.remove(
                                setCitation[itemIndex],
                              );
                            },
                            child: Text('Delete'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
