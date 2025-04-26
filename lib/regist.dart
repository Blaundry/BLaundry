import 'package:flutter/material.dart';
import 'welcome.dart';

class RegistPage extends StatefulWidget {
  const RegistPage({super.key});

  @override
  _RegistPageState createState() => _RegistPageState();
}

class _RegistPageState extends State<RegistPage> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  void _showSuccessMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Registration Success!', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    // Menunggu snackbar tampil selama 2 detik sebelum berpindah halaman
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => WelcomePage()),
        (route) => false,
      );
    });
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
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Register', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const Text('Please enter your name and password', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 15),

                  const Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                  const SizedBox(height: 10),

                  const Text('Password', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextField(
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      suffixIcon: IconButton(
                        icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  const Text('Confirm Password', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextField(
                    obscureText: !_isConfirmPasswordVisible,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      suffixIcon: IconButton(
                        icon: Icon(_isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _showSuccessMessage(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text('Register', style: TextStyle(color: Colors.white, fontSize: 16)),
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
