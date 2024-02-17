import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FacultyInfo extends StatefulWidget {
  final String name;
  final String designation;
  final String imagePath;
  final String description;
  final String postimage;

  const FacultyInfo({
    required this.name,
    required this.designation,
    required this.imagePath,
    required this.description,
    required this.postimage,
  });

  @override
  _FacultyInfoState createState() => _FacultyInfoState();
}

class _FacultyInfoState extends State<FacultyInfo> {
  int likes = 0;
  int dislikes = 0;
  late DocumentSnapshot facultySnapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            child: Image.network(
              widget.postimage,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(widget.imagePath),
                  ),
                  title: Text(
                    widget.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    widget.designation,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  widget.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          likes++;
                        });
                      },
                      icon: Icon(Icons.thumb_up),
                      label: Text(
                        "Like ($likes)",
                        style: TextStyle(fontSize: 14),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          dislikes++;
                        });
                      },
                      icon: Icon(Icons.thumb_down),
                      label: Text(
                        "Dislike ($dislikes)",
                        style: TextStyle(fontSize: 14),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Community extends StatefulWidget {
  const Community({Key? key}) : super(key: key);

  @override
  _CommunityState createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  late Stream<QuerySnapshot> facultyStream;

  @override
  void initState() {
    super.initState();
    facultyStream =
        FirebaseFirestore.instance.collection('faculty').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: Color(0xFFEA0027), // Reddit red color
        title: Text(
          "Electronics Engg. Community",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevation: 0, // Remove app bar shadow
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: facultyStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Column(
                children: snapshot.data!.docs.map((document) {
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  return FacultyInfo(
                    name: data['name'] ?? "",
                    designation: data['designation'] ?? "",
                    imagePath: data['imagePath'] ?? "",
                    description: data['description'] ?? "",
                    postimage: data['postimage'] ?? "",
                  );
                }).toList(),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add any action on button press
        },
        child: Icon(Icons.update),
        backgroundColor: Color(0xFFEA0027),
      ),
    );
  }
}
