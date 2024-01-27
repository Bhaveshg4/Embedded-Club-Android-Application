import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/AdminHome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({Key? key});

  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
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
          .doc('greetingDocument')
          .get();
      return snapshot['text'];
    } catch (e) {
      // Handle errors (e.g., document not found)
      print('Error fetching greeting text: $e');
      return null;
    }
  }

  Future<bool> isAdminEmail(String email) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('scanadmin')
          .where('email', isEqualTo: email)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking admin email: $e');
      return false;
    }
  }

  void showErrorMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Access Denied'),
          content: Text(
              'You are not allowed to sign in. You are not an admin. Contact the developer for help.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 52, 95, 214),
        title: const Text(
          'Admin logIn',
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
                              color: const Color.fromARGB(255, 255, 255, 255),
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(
                      height: 15,
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
                        "Admin Login",
                        style: TextStyle(fontSize: 24, color: Colors.amber),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    InkWell(
                      onTap: () async {
                        try {
                          await _googleSignIn.signIn();
                          GoogleSignInAccount? user = _googleSignIn.currentUser;

                          if (user != null) {
                            bool isAdmin = await isAdminEmail(user.email);

                            if (isAdmin) {
                              await FirebaseFirestore.instance
                                  .collection('signinadmin')
                                  .add({
                                'email': user.email,
                              });

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AdminHome(),
                                ),
                              );
                            } else {
                              showErrorMessage();
                            }
                          } else {
                            print('Google Sign-In failed');
                          }
                        } catch (error) {
                          print('Google Sign-In error: $error');
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Sign in with ",
                            style: TextStyle(fontSize: 24, color: Colors.amber),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            height: 150,
                            width: 150,
                            child: Image.asset("assets/Untitled.png"),
                          ),
                        ],
                      ),
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
