import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Developer extends StatelessWidget {
  const Developer({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Developer Information'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/background_home.jpg',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Center(
            child: Card(
              margin: const EdgeInsets.all(20),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('developer_info')
                      .doc('developerDetails')
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    if (!snapshot.hasData || snapshot.data!.data() == null) {
                      return const Text('No developer information found');
                    }

                    var data = snapshot.data!.data() as Map<String, dynamic>;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Developed by",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${data['developerName'] ?? 'Unknown'}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Email: ${data['developerEmail'] ?? 'No email available'}',
                          style: TextStyle(
                            fontSize: 16,
                            color: const Color.fromARGB(255, 88, 85, 85),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'About:',
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${data['developerDescription'] ?? 'No description available'}',
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: Developer(),
    ),
  );
}
