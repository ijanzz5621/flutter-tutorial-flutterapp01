import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tutorial_app01/views/widgets/home_sel_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // HeroWidget(),
        Lottie.asset('assets/lotties/home-map.json', height: 200.0),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 5.0),
          child: HomeSelWidget(),
        ),
      ],
    );
  }
}
