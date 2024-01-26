import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController branchController = TextEditingController();
  final TextEditingController sectionController = TextEditingController();
  final TextEditingController rollNumberController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 73, 70, 70),
        title: Text(
          'Register for the Event',
          style: TextStyle(
            fontSize: 25,
            color: Color.fromARGB(255, 255, 254, 254),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background_home.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTextFieldContainer(
                    child: TextFormField(
                      controller: eventNameController,
                      decoration: InputDecoration(
                        labelText: 'Event Name',
                        icon: Icon(Icons.event),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Event Name is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTextFieldContainer(
                    child: TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        icon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Name is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTextFieldContainer(
                    child: TextFormField(
                      controller: branchController,
                      decoration: InputDecoration(
                        labelText: 'Branch',
                        icon: Icon(Icons.business),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Branch is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTextFieldContainer(
                    child: TextFormField(
                      controller: sectionController,
                      decoration: InputDecoration(
                        labelText: 'Section',
                        icon: Icon(Icons.list),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Section is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTextFieldContainer(
                    child: TextFormField(
                      controller: rollNumberController,
                      decoration: InputDecoration(
                        labelText: 'Roll Number',
                        icon: Icon(Icons.confirmation_number),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Roll Number is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        String eventName = eventNameController.text;
                        String name = nameController.text;
                        String branch = branchController.text;
                        String section = sectionController.text;
                        String rollNumber = rollNumberController.text;

                        await FirebaseFirestore.instance
                            .collection('registrations')
                            .add({
                          'eventName': eventName,
                          'name': name,
                          'branch': branch,
                          'section': section,
                          'rollNumber': rollNumber,
                        });

                        // Show a pop-up dialog for registration success
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Registration Successful!'),
                              content: Text('Thank you for registering.'),
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

                        // Clear the form fields after successful registration
                        eventNameController.clear();
                        nameController.clear();
                        branchController.clear();
                        sectionController.clear();
                        rollNumberController.clear();
                      }
                    },
                    child: Text('Register'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldContainer({required Widget child}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.purple],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: child,
    );
  }
}
