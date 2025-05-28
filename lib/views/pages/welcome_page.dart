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
            FittedBox(
              child: Text(
                'MILOCA',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 50.0,
                  letterSpacing: 30.0,
                ),
              ),
            ),
            HeroWidget(),
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
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 50.0),
                backgroundColor: Colors.teal,
              ),
              child: Text('Get Started'),
            ),
            TextButton(
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
              style: TextButton.styleFrom(
                minimumSize: const Size(double.infinity, 50.0),
              ),
              child: Text('Log In'),
            ),
          ],
        ),
      ),
    );
  }
}
