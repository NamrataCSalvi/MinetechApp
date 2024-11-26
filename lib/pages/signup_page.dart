import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'team_actions_page.dart'; // Import the team actions page
import 'team_list_page.dart'; // Import the team list page

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String errorMessage = '';

  void signupUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Create user with email and password
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        // Get user ID from FirebaseAuth
        final userId = userCredential.user!.uid;

        // Save user information in Firestore
        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'firstName': firstNameController.text.trim(),
          'middleName': middleNameController.text.trim(),
          'lastName': lastNameController.text.trim(),
          'email': emailController.text.trim(),
          'teams': [], // Initialize empty list for teams
        });

        // Check if the user has joined any teams
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();
        if (userDoc.exists) {
          List teams = userDoc['teams'];

          // If user has joined any teams, navigate to the team list page
          if (teams.isNotEmpty) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      TeamListPage()), // Navigate to the team list page
            );
          } else {
            // If the user hasn't joined any teams, navigate to the team actions page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      TeamActionsPage()), // Navigate to team actions page
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          errorMessage = e.message ?? 'An unknown error occurred';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        titleTextStyle: TextStyle(
            color: Colors.blue[400], fontSize: 25, fontWeight: FontWeight.w700),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  labelStyle: TextStyle(
                      color: Colors.blue[400],
                      fontSize: 16,
                      fontWeight: FontWeight.w300), // Changed to blue
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.blue[400]!), // Bottom border color
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors
                            .blue[600]!), // Bottom border color when focused
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'First Name cannot be empty';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: middleNameController,
                decoration: InputDecoration(
                  labelText: 'Middle Name',
                  labelStyle: TextStyle(
                      color: Colors.blue[400],
                      fontSize: 16,
                      fontWeight: FontWeight.w300), // Changed to blue
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.blue[400]!), // Bottom border color
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors
                            .blue[600]!), // Bottom border color when focused
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Middle Name cannot be empty';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  labelStyle: TextStyle(
                      color: Colors.blue[400],
                      fontSize: 16,
                      fontWeight: FontWeight.w300), // Changed to blue
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.blue[400]!), // Bottom border color
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors
                            .blue[600]!), // Bottom border color when focused
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Last Name cannot be empty';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                      color: Colors.blue[400],
                      fontSize: 16,
                      fontWeight: FontWeight.w300), // Changed to blue
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.blue[400]!), // Bottom border color
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors
                            .blue[600]!), // Bottom border color when focused
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email cannot be empty';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(
                      color: Colors.blue[400],
                      fontSize: 16,
                      fontWeight: FontWeight.w300),
                  // Changed to blue
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.blue[400]!), // Bottom border color
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors
                            .blue[600]!), // Bottom border color when focused
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password cannot be empty';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              if (errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: signupUser,
                child: Text(
                  'Sign up',
                  style: TextStyle(
                    color: Colors.blue[400],
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
