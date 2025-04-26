import 'package:flutter/material.dart';
import 'startpage.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins', // Gunakan font secara global
      ),
      home: StartPage(), // Halaman pertama adalah StartPage
    );
  }
}

