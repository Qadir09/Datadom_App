import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datadom/view/CreateAcount.dart';
import 'package:datadom/view/Resetpassword.dart';
import 'package:datadom/view/Admindashbaord.dart'; // Admin Dashboard
import 'package:datadom/view/dashboard.dart'; // Regular User Dashboard
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();

    Future<void> signIn({required bool isAdminLogin}) async {
      try {
        // Authenticate the user
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text.trim(),
          password: password.text.trim(),
        );

        // Fetch user details from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('user_detail')
            .doc(userCredential.user!.uid)
            .get();

        // Check if the user is an admin
        bool isAdmin = userDoc['isAdmin'] ?? false;

        if (isAdminLogin) {
          if (isAdmin) {
            // Navigate to Admin Dashboard
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AdminDashboard()),
            );
          } else {
            throw Exception("Admin access required. You are not an admin.");
          }
        } else {
          // Regular user login
          if (!isAdmin) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => dashboard()),
            );
          } else {
            throw Exception("User access required. Admins cannot log in here.");
          }
        }
      } catch (e) {
        // Show error message if login fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login failed: $e")),
        );
      }
    }

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.1, // Dynamic vertical padding
            horizontal: screenWidth * 0.1, // Dynamic horizontal padding
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/images/image.png',
                  fit: BoxFit.cover,
                ),
              ),
              Text('DataDom',
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              const Text(
                'Login Your Account',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 20),
              // Email TextField
              TextField(
                controller: email,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Your Email',
                ),
              ),
              const SizedBox(height: 20),
              // Password TextField
              TextField(
                controller: password,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Your Password',
                ),
              ),
              const SizedBox(height: 20),
              // Login Buttons (Regular User and Admin)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => signIn(isAdminLogin: true),
                    child: const Text(
                      'Login as User',
                      //   style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => signIn(isAdminLogin: true),
                    style: ElevatedButton.styleFrom(
                        //  shadowColor: Colors.black, // Admin button color
                        ),
                    child: const Text(
                      'Login as Admin',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateAccount()),
                  );
                },
                child: const Text('Create new account'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => forgotpasswordscreen()),
                  );
                },
                child: const Text('Forgot password?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
