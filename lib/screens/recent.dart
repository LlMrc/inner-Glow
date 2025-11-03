import 'package:flutter/material.dart';
import 'package:nodus_application/local/database_helper.dart';
import 'package:nodus_application/screens/display_citation.dart';
import 'package:nodus_application/services/google_ads_heleper.dart';

class Recent extends StatefulWidget {
  const Recent({super.key});

  @override
  State<Recent> createState() => _RecentState();
}

class _RecentState extends State<Recent> {
  final citationList = StringListDatabaseHelper.instance;

  Future<void> initCitationList() async {
    await citationList.getList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recent Edits')),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          FutureBuilder(
            future: citationList.getList(),
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
                    'No citations available.',
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
                      horizontal: 14.0,
                      vertical: 12.0,
                    ),
                    child: Card(
                      elevation: 6,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.wb_sunny_rounded,
                              color: Colors.red,
                              size: 24,
                            ),
                            SizedBox(height: 8),
                            Text(
                              maxLines: 3,
                              setCitation[itemIndex],
                              style: TextStyle(
                                fontSize: 16,

                                fontFamily: 'Montserrat',
                              ),
                            ),
                            SizedBox(height: 12),
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
                                    await citationList.remove(
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
              await initCitationList();
              setState(() {});
            },
            icon: Icon(Icons.refresh, size: 34),
          ),
        ],
      ),
    );
  }
}

  // Méthode simulée pour envoyer un feedback
  // void _sendFeedback(BuildContext context) {
  //   // Ici, vous ouvririez un email client ou un formulaire in-app
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text('Ouvrir la boîte de dialogue de feedback')),
  //   );
  //   if (kDebugMode) {
  //     print("Ouvrir la boîte de dialogue de feedback");
  //   }
  // }

