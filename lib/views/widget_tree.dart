import 'package:flutter/material.dart';
import 'package:tutorial_app01/data/notifiers.dart';
import 'package:tutorial_app01/views/pages/home_page.dart';
import 'package:tutorial_app01/views/pages/map_page.dart';
import 'package:tutorial_app01/views/pages/profile_page.dart';
import 'package:tutorial_app01/views/pages/setting_page.dart';
import 'package:tutorial_app01/views/widgets/navbar_widget.dart';

List<Widget> pages = [HomePage(), MapPage(), ProfilePage()];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MILOCA'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  fullscreenDialog: false,
                  barrierDismissible: false,
                  builder: (context) {
                    return const SettingPage(title: "My Settings");
                  },
                ),
              );
            },
            icon: Icon(Icons.settings),
          ),
          IconButton(
            onPressed: () {
              isDarkModeNotifier.value = !isDarkModeNotifier.value;
            },
            icon: ValueListenableBuilder(
              valueListenable: isDarkModeNotifier,
              builder: (context, isDarkMode, child) {
                return Icon(
                  isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  color: isDarkMode ? Colors.yellow : Colors.grey,
                );
              },
            ),
          ),
        ],
      ),

      // body: pages.elementAt(0), // home page as default
      body: ValueListenableBuilder(
        valueListenable: selectedPageNotifier,
        builder: (context, selectedPage, child) {
          return pages.elementAt(selectedPage);
        },
      ),
      bottomNavigationBar: NavBarWidget(),
    );
  }
}
