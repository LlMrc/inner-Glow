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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorite Citations')),
      body: FutureBuilder(
        future: favoriteCitationList.getList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final citations = snapshot.data as List<String>;
            if (citations.isEmpty) {
              return Center(child: Text('No recent edits found.'));
            }
            final maxItems = citations.length > 10 ? 10 : citations.length;
            return ListView.builder(
              itemCount: maxItems + (maxItems ~/ 4), // Add extra slots for ads
              itemBuilder: (context, index) {
                // Calculate the actual index in the citations list
                final itemIndex = index - (index ~/ 5);

                // Insert banner ad after every 4 items
                if ((index + 1) % 5 == 0) {
                  return BannerAdWidget();
                }

                return Container(
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
                      colors: [
                        Colors.deepPurple.shade200,
                        Colors.pink.shade100,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lightbulb_outline_rounded, size: 16),
                      Text(
                        citations[itemIndex],
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DisplayCitation(
                                    citationText: citations[itemIndex],
                                  ),
                                ),
                              );
                            },
                            child: Text('Edit'),
                          ),
                          TextButton(
                            onPressed: () {
                              favoriteCitationList.remove(citations[itemIndex]);
                            },
                            child: Text('Delete'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
