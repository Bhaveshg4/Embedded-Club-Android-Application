import 'package:flutter/material.dart';

class TeamMembersPage extends StatelessWidget {
  final List<MemberData> members = [
    MemberData('Tanmaya Kale'),
    MemberData('Sarvesh Zade'),
    MemberData('Isha Sinha'),
    MemberData('Vedant Ghadole'),
    MemberData('Aruja Singh'),
    MemberData('Mahi Malviya'),
    MemberData('Malika'),
    MemberData('Ved'),
    MemberData('Ved'),
    MemberData('Bhavesh Gupta'),
    MemberData('Aditya Mande'),
    MemberData('Tanuj Sir'),
    MemberData('Anushka Kawathekar'),
    MemberData('Poorvi Verma'),
    MemberData('Jagruti'),
    MemberData('Sameer Hate'),
    MemberData('Sayali Dongre'),
    MemberData('  Shriraj Dekhate'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Team Members',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background_team.jpg', // Replace with your image asset path
              fit: BoxFit.cover,
            ),
          ),

          // Page Content
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                for (var member in members)
                  Padding(
                    padding: EdgeInsets.only(left: 6, right: 6, top: 5),
                    child: Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          colors: [
                            Colors.blue,
                            Colors.purple
                          ], // Adjust gradient colors
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.account_circle,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                          Text(
                            member.name,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Add more content widgets as needed
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MemberData {
  final String name;

  MemberData(this.name);
}
