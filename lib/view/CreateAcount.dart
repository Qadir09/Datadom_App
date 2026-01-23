// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CreateAccount extends StatelessWidget {
  CreateAccount({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController number = TextEditingController();
  final TextEditingController password = TextEditingController();
  String accountType = 'User'; // Default account type

  void _signup(BuildContext context) async {
    try {
      // Create user in Firebase Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      // Save user details to Firestore
      CollectionReference collRef =
          FirebaseFirestore.instance.collection('user_detail');
      await collRef.doc(userCredential.user!.uid).set({
        'firstName': firstName.text,
        'lastName': lastName.text,
        'email': email.text,
        'password': password.text,
        'number': number.text,
        'isAdmin': accountType == 'Admin', // Save account type
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Notify success
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Signup Successful as $accountType! Welcome ${userCredential.user!.email}"),
        ),
      );

      // Clear input fields
      firstName.clear();
      lastName.clear();
      email.clear();
      password.clear();
      number.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Signup Failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.05,
            horizontal: screenWidth * 0.1,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Create Your New Account',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(firstName, 'Enter First Name'),
              const SizedBox(height: 20),
              _buildTextField(lastName, 'Enter Last Name'),
              const SizedBox(height: 20),
              _buildTextField(email, 'Enter Email'),
              const SizedBox(height: 20),
              _buildTextField(password, 'Enter Password', isPassword: true),
              const SizedBox(height: 20),
              _buildTextField(number, 'Enter Number'),
              const SizedBox(height: 20),
              _buildDropdown(),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => _signup(context),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String labelText, {
    bool isPassword = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: labelText,
        ),
        style: const TextStyle(color: Colors.blue),
      ),
    );
  }

  Widget _buildDropdown() {
    return SizedBox(
      width: double.infinity,
      child: DropdownButtonFormField<String>(
        value: accountType,
        items: const [
          DropdownMenuItem(value: 'User', child: Text('User')),
          DropdownMenuItem(value: 'Admin', child: Text('Admin')),
        ],
        onChanged: (value) {
          accountType = value!;
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Account Type',
        ),
      ),
    );
  }
}
