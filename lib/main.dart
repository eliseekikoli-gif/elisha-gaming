import 'package:flutter/material.dart';

void main() {
  runApp(const EliShaGamingApp());
}

class EliShaGamingApp extends StatelessWidget {
  const EliShaGamingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eli Sha Gaming',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F1015),
        primaryColor: const Color(0xFFFF6B00),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eli Sha Gaming'),
        backgroundColor: const Color(0xFF1E1F28),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.sports_esports, size: 80, color: Color(0xFFFF6B00)),
            SizedBox(height: 16),
            Text(
              'Eli Sha Gaming',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 8),
            Text(
              'Bienvenue sur l\'application mobile',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
