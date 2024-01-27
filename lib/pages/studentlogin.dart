import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/homepage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentLogin extends StatefulWidget {
  const StudentLogin({Key? key});

  @override
  _StudentLoginState createState() => _StudentLoginState();
}

class _StudentLoginState extends State<StudentLogin> {
  late Future<String?> greetingText;
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  @override
  void initState() {
    super.initState();
    greetingText = fetchGreetingText();
  }

  Future<String?> fetchGreetingText() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('greeting')
          .doc('greetingDocumentStudent')
          .get();
      return snapshot['text'];
    } catch (e) {
      // Handle errors (e.g., document not found)
      print('Error fetching greeting text: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 52, 95, 214),
        title: const Text(
          ' Student Login',
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          Center(
            child: Card(
              color: Color.fromARGB(0, 233, 227, 227),
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FutureBuilder<String?>(
                      future: greetingText,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError || snapshot.data == null) {
                          return SizedBox.shrink();
                        } else {
                          return Text(
                            snapshot.data!,
                            style: TextStyle(
                                fontSize: 24,
                                color:
                                    const Color.fromARGB(255, 255, 255, 255)),
                          );
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 40,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "Student Login",
                        style: TextStyle(fontSize: 24, color: Colors.amber),
                      ),
                    ),
                    const SizedBox(height: 9),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Sign in with ",
                          style: TextStyle(fontSize: 24, color: Colors.amber),
                        ),
                        const SizedBox(width: 9),
                        InkWell(
                          onTap: () async {
                            try {
                              await _googleSignIn.signIn();
                              GoogleSignInAccount? user =
                                  _googleSignIn.currentUser;

                              if (user != null) {
                                await FirebaseFirestore.instance
                                    .collection('signinusers')
                                    .add({
                                  'email': user.email,
                                });

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(),
                                  ),
                                );
                              } else {
                                print('Google Sign-In failed');
                              }
                            } catch (error) {
                              print('Google Sign-In error: $error');
                            }
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset("assets/Untitled.png"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
