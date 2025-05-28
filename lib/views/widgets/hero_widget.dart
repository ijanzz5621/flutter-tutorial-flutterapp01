import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HeroWidget extends StatelessWidget {
  const HeroWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'hero-welcome-page',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Stack(
          children: [
            Image.asset(
              'assets/images/image01.jpg',
              width: double.infinity,
              height: 300.0,
              fit: BoxFit.cover,
              color: Colors.teal,
              colorBlendMode: BlendMode.darken,
            ),
            Lottie.asset('assets/lotties/home-anim.json'),
          ],
        ),
      ),
    );
  }
}
