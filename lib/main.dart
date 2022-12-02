import 'package:flutter/material.dart';

import 'package:password_app/home_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Password App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light()
      ),
      home: const HomePage()
    );
  }
}