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

  Future<void> initFavoriteList() async {
    await favoriteCitationList.getFavoriteCitationList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorite Citations')),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          FutureBuilder(
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
              final maxItems = setCitation.length > 10
                  ? 10
                  : setCitation.length;
              return ListView.builder(
                itemCount:
                    maxItems + (maxItems ~/ 4), // Add extra slots for ads
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
                    child: Card(
                      elevation: 4,
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.favorite_border_outlined,
                              size: 16,
                              color: Colors.deepPurpleAccent,
                            ),
                            SizedBox(height: 8),
                            Text(
                              setCitation[itemIndex],
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.54),
                                fontSize: 18,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w300,
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
                                  onPressed: () async {
                                    await favoriteCitationList
                                        .removeFavoriteCitation(
                                          setCitation[itemIndex],
                                        );

                                    setState(() {});
                                  },
                                  child: Text('Delete'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          IconButton(
            onPressed: () async {
              await initFavoriteList();
              setState(() {});
            },
            icon: Icon(Icons.refresh, size: 34),
          ),
        ],
      ),
    );
  }
}
