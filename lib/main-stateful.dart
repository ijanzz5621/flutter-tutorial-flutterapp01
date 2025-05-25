import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// stateless
// material app
// scaffold

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
          contrastLevel: 0.5,
        ),
      ),
      home: MyHomePage(key: const Key('home_page')),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo'),
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Action when settings icon is pressed
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Action when settings icon is pressed
            },
          ),
        ],
        backgroundColor: Colors.teal,
      ),
      drawer: SafeArea(
        child: Drawer(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: 50.0,
                  child: DrawerHeader(
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(color: Colors.teal),
                    child: Align(
                      child: Text(
                        'Options',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.account_circle),
                  title: const Text('Profile'),
                  onTap: () {
                    // Action when the profile drawer item is tapped
                    // Navigator.pop(context); // Close the drawer
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          NavigationDestination(icon: Icon(Icons.history), label: 'History'),
          NavigationDestination(
            icon: Icon(Icons.open_in_browser),
            label: 'Browse',
          ),
          NavigationDestination(icon: Icon(Icons.close), label: 'Exit'),
        ],
        onDestinationSelected: (int value) {
          setState(() {
            currentIndex = value;
          });
        },
        selectedIndex: currentIndex,
      ),
      body: currentIndex == 0
          ? Center(
              child: Text(
                'Home Page',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            )
          : Center(
              child: Text(
                'Selected Index: $currentIndex',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () {
              // Action when the button is pressed
              print('Floating Action Button 1 Pressed');
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: const Icon(Icons.add),
          ),
          SizedBox(height: 10.0),
          FloatingActionButton(
            onPressed: () {
              // Action when the button is pressed
              print('Floating Action Button 2 Pressed');
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
