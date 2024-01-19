import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/homepage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key});

  @override
  Widget build(BuildContext context) {
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    // Google Sign-In
    GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Text(
          'Embedded Club Login',
          style: TextStyle(color: Colors.blue),
        ),
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Dark Overlay to Enhance Text Visibility
          Container(
            color: Colors.black.withOpacity(0.5),
          ),

          // Transparent Login Form
          Center(
            child: Card(
              color: Color.fromARGB(0, 233, 227, 227),
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Username TextField
                      TextFormField(
                        controller: usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),

                      // Password TextField
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24.0),

                      // Login Button
                      ElevatedButton(
                        onPressed: () {
                          // Validate form
                          if (formKey.currentState!.validate()) {
                            // Form is valid, perform login
                            String username = usernameController.text;
                            String password = passwordController.text;

                            // Replace the following check with your actual login logic
                            if (username == 'U' && password == 'P') {
                              // Navigate to HomePage on successful login
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePage(),
                                ),
                              );
                            } else {
                              // Handle invalid login credentials
                              print('Invalid credentials');
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Google Sign-In Button
                      InkWell(
                        onTap: () async {
                          try {
                            await _googleSignIn.signIn();
                            GoogleSignInAccount? user =
                                _googleSignIn.currentUser;

                            // Perform additional logic or navigate to HomePage
                            if (user != null) {
                              // Navigate to HomePage on successful login
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePage(),
                                ),
                              );
                            } else {
                              // Handle unsuccessful login
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
                            borderRadius: BorderRadius.circular(70),
                            child: Image.asset("assets/Untitled.png"),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
