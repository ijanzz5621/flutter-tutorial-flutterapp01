import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Material app (Stateful)
// Scaffold
// AppBar
// BottomNavigationBar
// setState

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currentMenuIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
          contrastLevel: 0.5,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(title: Text('Flutter Tutorial')),
        bottomNavigationBar: NavigationBar(
          destinations: [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          ],
          selectedIndex: currentMenuIndex,
          onDestinationSelected: (value) {
            setState(() {
              currentMenuIndex = value;
            });
          },
        ),
      ),
    );
  }
}
