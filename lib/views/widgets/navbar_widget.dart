import 'package:flutter/material.dart';
import 'package:tutorial_app01/data/notifiers.dart';

class NavBarWidget extends StatelessWidget {
  const NavBarWidget({super.key});

  // int currentMenuIndex = 0;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedPage, child) {
        return NavigationBar(
          destinations: [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.add), label: 'Add'),
            NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          ],
          //selectedIndex: currentMenuIndex,
          selectedIndex: selectedPage,
          onDestinationSelected: (value) {
            // setState(() {
            //   currentMenuIndex = value;
            // });
            selectedPageNotifier.value = value;
          },
        );
      },
    );
  }
}
