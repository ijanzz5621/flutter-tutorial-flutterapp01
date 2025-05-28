import 'package:flutter/material.dart';
import 'package:tutorial_app01/views/widget_tree.dart';
import 'package:tutorial_app01/views/widgets/hero_widget.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HeroWidget(),
            Text(
              'Welcome to Sharizan App',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
            ),
            SizedBox(height: 20.0),
            FilledButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    fullscreenDialog: false,
                    barrierDismissible: false,
                    builder: (context) {
                      return const WidgetTree();
                    },
                  ),
                );
              },
              child: Text('Log In'),
            ),
          ],
        ),
      ),
    );
  }
}
