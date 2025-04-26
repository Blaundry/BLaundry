import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'login_customer.dart';
import 'login_admin.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              // Header Biru dengan Logo
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
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Bagian Login dan Register
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                child: Column(
                  children: [
                    const Text(
                      'Welcome !',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Clean Laundry, Peace of Mind',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 20),

                    // Login as Customer
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginCustomerPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Login', style: TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Are you an admin? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginAdminPage()));
                          },
                          child: const Text(
                            'login',
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

          // Logo kecil di tengah bawah
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              'assets/logosimple4.png',
              width: 100,

            ),
          ),

          // Wave Animation hanya terlihat setengahnya
          Positioned(
            bottom: -MediaQuery.of(context).size.height * 0.005, // Geser ke bawah agar setengahnya tersembunyi
            left: 0,
            right: 0,
            child: Lottie.asset(
              'assets/wave.json',
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.125, // Hanya tampil setengahnya
              fit: BoxFit.cover,
              alignment: Alignment.bottomCenter,
            ),
          ),
        ],
      ),
    );
  }
}
