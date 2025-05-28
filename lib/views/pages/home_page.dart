import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tutorial_app01/data/constants.dart';

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
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Basic Layout', style: KTextStyle.titleTealText),
                  Text(
                    'The description of the card',
                    style: KTextStyle.descriptionTealText,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
