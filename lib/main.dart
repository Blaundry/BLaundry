import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/startpage.dart';
import 'package:blaundry_registlogin/services/firebase_options.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,  // Use the correct options
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      home: const StartPage(), // Halaman pertama
    );
  }
}
