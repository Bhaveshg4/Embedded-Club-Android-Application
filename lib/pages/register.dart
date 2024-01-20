import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController branchController = TextEditingController();
  final TextEditingController sectionController = TextEditingController();
  final TextEditingController rollNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 73, 70, 70),
        title: Text(
          'Register for the Event',
          style: TextStyle(
              fontSize: 25, color: Color.fromARGB(255, 255, 254, 254)),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextFieldContainer(
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
              ),
              const SizedBox(height: 16),
              _buildTextFieldContainer(
                child: TextField(
                  controller: branchController,
                  decoration: InputDecoration(labelText: 'Branch'),
                ),
              ),
              const SizedBox(height: 16),
              _buildTextFieldContainer(
                child: TextField(
                  controller: sectionController,
                  decoration: InputDecoration(labelText: 'Section'),
                ),
              ),
              const SizedBox(height: 16),
              _buildTextFieldContainer(
                child: TextField(
                  controller: rollNumberController,
                  decoration: InputDecoration(labelText: 'Roll Number'),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  String name = nameController.text;
                  String branch = branchController.text;
                  String section = sectionController.text;
                  String rollNumber = rollNumberController.text;

                  if (name.isEmpty ||
                      branch.isEmpty ||
                      section.isEmpty ||
                      rollNumber.isEmpty) {
                    return;
                  }

                  await FirebaseFirestore.instance
                      .collection('registrations')
                      .add({
                    'name': name,
                    'branch': branch,
                    'section': section,
                    'rollNumber': rollNumber,
                  });

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Registration successful!'),
                  ));
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.purple],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: child,
      ),
    );
  }
}
