import 'package:flutter/material.dart';
import 'package:tutorial_app01/data/notifiers.dart';
import 'package:tutorial_app01/views/pages/welcome_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDarkMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blueAccent,
              brightness: isDarkMode ? Brightness.dark : Brightness.light,
              contrastLevel: 0.5,
            ),
          ),
          home: WelcomePage(),
        );
      },
    );
  }
}
