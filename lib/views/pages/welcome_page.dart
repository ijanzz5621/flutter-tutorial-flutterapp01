import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tutorial_app01/views/widget_tree.dart';
import 'package:tutorial_app01/views/widgets/hero_widget.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
    // Lock the screen to portrait mode when this page is initialized
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    // Before leaving the page, reset the orientation to allow all orientations
    // for other parts of the app, or for the system default behavior.
    // This is crucial to avoid locking the entire app if not intended.
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/welcome-bg.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment:
                    CrossAxisAlignment.stretch, // To make buttons stretch
                children: [
                  const Spacer(),
                  FittedBox(
                    child: Stack(
                      children: [
                        Text(
                          'MILOCA',
                          style: GoogleFonts.brunoAceSc(
                            // Changed to GoogleFonts.montserrat
                            fontWeight: FontWeight.bold,
                            fontSize: 40.0,
                            letterSpacing:
                                5.0, // Keep this value or adjust as desired
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth =
                                  3.0 // Outline thickness
                              ..color = Colors.black, // Outline color
                            // shadows: null, // Ensure shadows are removed if you want a clean look
                          ),
                        ),
                        // Fill Text (on top of outline)
                        Text(
                          'MILOCA',
                          style: GoogleFonts.brunoAceSc(
                            fontWeight: FontWeight.bold,
                            fontSize: 40.0,
                            letterSpacing: 5.0,
                            color: Colors.white, // Fill color of the text
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
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
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    child: Text('Get Started'),
                  ),
                  Padding(padding: EdgeInsetsGeometry.symmetric(vertical: 10)),
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
                    style: TextButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50.0),
                      backgroundColor: Colors.black, // Set background to black
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Log In'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
