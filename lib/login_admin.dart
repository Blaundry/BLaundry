import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:blaundry_registlogin/dashboard_Admin.dart';
import 'package:blaundry_registlogin/welcome.dart';

class LoginAdminPage extends StatefulWidget {
  const LoginAdminPage({super.key});

  @override
  State<LoginAdminPage> createState() => _LoginAdminPageState();
}

class _LoginAdminPageState extends State<LoginAdminPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordHidden = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _validateAndLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty) {
      _showMessage('Email cannot be empty', Colors.red);
      return;
    }

    if (password.length < 6 || password.length > 8) {
      _showMessage('Password must be between 6 and 8 characters', Colors.red);
      return;
    }

    try {
      // 🔍 Check if the email exists in Firestore before logging in
      final userQuery = await _firestore.collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (userQuery.docs.isEmpty) {
        _showMessage('Email not found. Please check your credentials.', Colors.red);
        return;
      }

      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user?.uid;
      if (uid == null) {
        _showMessage('Authentication failed. Try again.', Colors.red);
        return;
      }

      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) {
        _showMessage('User data not found', Colors.red);
        return;
      }

      final role = doc['role'];
      if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardAdminPage()),
        );
      } else {
        _showMessage('You are not authorized as admin', Colors.red);
      }
    } on FirebaseAuthException catch (e) {
      _showMessage(e.message ?? 'Login failed. Please try again.', Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const WelcomePage()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.28,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              alignment: Alignment.center,
              child: const Text(
                'B-Laundry Admin',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Login Admin',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Please enter your email and password',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Email',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Password',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: _passwordController,
                    obscureText: _isPasswordHidden,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(_isPasswordHidden
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _isPasswordHidden = !_isPasswordHidden;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _validateAndLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
