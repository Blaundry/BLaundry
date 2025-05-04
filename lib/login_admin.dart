import 'package:flutter/material.dart';
import 'package:blaundry_registlogin/dashboard_Admin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginAdminPage extends StatefulWidget {
  const LoginAdminPage({super.key});

  @override
  _LoginAdminPageState createState() => _LoginAdminPageState();
}

class _LoginAdminPageState extends State<LoginAdminPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordHidden = true;

  void _validateAndLogin() async {
    String email = _nameController.text.trim();
    String password = _passwordController.text;

    if (email.isEmpty) {
      _showMessage('Name cannot be empty');
    } else if (password.length < 6 || password.length > 8) {
      _showMessage('Password must be 6-8 characters');
    } else {
      try {

        // Login ke Firebase Auth
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

        // Ambil UID
        String uid = userCredential.user!.uid;

        // Ambil dokumen user dari Firestore
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();

        // Cek apakah dokumen user ada
        if (userDoc.exists) {
          String role = userDoc['role'];
          if (role == 'admin') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const DashboardAdminPage()),
            );
          } else {
            _showMessage('You are not an admin');
          }
        } else {
          _showMessage('User data not found');
        }
      } on FirebaseAuthException catch (e) {
        _showMessage(e.message ?? 'Login failed');
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.35,
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              alignment: Alignment.center,
              child: const Text(
                'B-Laundry',
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Login Admin',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const Text('Please input email and password',
                      style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 15),
                  const Text('Email',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('Password',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextField(
                    controller: _passwordController,
                    obscureText: _isPasswordHidden,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordHidden
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
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
