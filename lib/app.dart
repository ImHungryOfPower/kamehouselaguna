import 'package:flutter/material.dart';
import 'theme.dart';
import 'pages/splash_page.dart';
import 'pages/home_page.dart';

class KameHouseApp extends StatelessWidget {
  const KameHouseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KameHouse Laguna',
      theme: AppTheme.light,
      home: const SplashPage(),
      routes: {
        '/home': (context) => const HomePage(),
      },
    );
  }
}
