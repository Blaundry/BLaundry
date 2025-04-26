import 'package:flutter/material.dart';
import 'regist.dart';
import 'dashboard.dart'; // Pastikan file dashboard.dart sudah ada

class LoginCustomerPage extends StatefulWidget {
  const LoginCustomerPage({super.key});

  @override
  _LoginCustomerPageState createState() => _LoginCustomerPageState();
}

class _LoginCustomerPageState extends State<LoginCustomerPage> {
  bool _isPasswordHidden = true;

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
                    fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Login', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const Text('Please input name and password', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 15),
                  const Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('Password', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextField(
                    obscureText: _isPasswordHidden,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordHidden ? Icons.visibility_off : Icons.visibility,
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
                      onPressed: () {
                        // Simulasi login berhasil
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => DashboardPage()),
                        );
                      },
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
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Didn't have an account yet? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => RegistPage()));
                        },
                        child: const Text(
                          'Register',
                          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
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