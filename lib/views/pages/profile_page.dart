import 'package:flutter/material.dart';
import 'package:tutorial_app01/data/notifiers.dart';
import 'package:tutorial_app01/views/pages/welcome_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/images/user-profile.png'),
          ),
          const SizedBox(height: 20),
          const Text(
            'Sharizan Redzuan',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Flutter Developer',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          ListTile(
            // tileColor: Colors.white,
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            titleAlignment: ListTileTitleAlignment.center,
            onTap: () {
              selectedPageNotifier.value = 0; // Reset to the first page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  fullscreenDialog: false,
                  barrierDismissible: false,
                  builder: (context) {
                    return const WelcomePage();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
