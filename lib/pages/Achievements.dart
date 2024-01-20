import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class AchievementsPostCard extends StatefulWidget {
  final String documentId;

  const AchievementsPostCard({Key? key, required this.documentId})
      : super(key: key);

  @override
  _AchievementsPostCardState createState() => _AchievementsPostCardState();
}

class _AchievementsPostCardState extends State<AchievementsPostCard> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> eventData;

  @override
  void initState() {
    super.initState();
    eventData = FirebaseFirestore.instance
        .collection('AchievementsPage')
        .doc(widget.documentId)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: eventData,
      builder: (context,
          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.data() == null) {
          return Text('No data found for documentId: ${widget.documentId}');
        } else {
          final eventData = snapshot.data!.data()!;

          return Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: eventData['profileImage'] != null
                        ? AssetImage(eventData['profileImage'])
                        : const AssetImage('fallback_image.png'),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          eventData['achievementName'] ?? 'Event Name',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Date: ${eventData['date'] ?? 'No Date'}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Location: ${eventData['location'] ?? 'No Location'}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                eventData['description'] ?? 'No Description',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Members Participated: ${eventData['teamMembers'] ?? 'Team Members'}',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 15),
            ]),
          );
        }
      },
    );
  }
}

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Achievements Of Club',
          style: TextStyle(color: Colors.white, fontSize: 27),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 52, 95, 214),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/background_home.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          FutureBuilder(
            future: Firebase.initializeApp(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('AchievementsPage')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return Text('No achievements found');
                    } else {
                      final achievementDocuments = snapshot.data!.docs;

                      return SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              for (var achievementDocument
                                  in achievementDocuments)
                                AchievementsPostCard(
                                  documentId: achievementDocument.id,
                                ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ],
      ),
    );
  }
}
