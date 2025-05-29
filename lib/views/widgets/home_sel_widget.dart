import 'package:flutter/material.dart';
import 'package:tutorial_app01/data/constants.dart';

class HomeSelWidget extends StatelessWidget {
  const HomeSelWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: [
        Card(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('How to Miloca?', style: KTextStyle.titleTealText),
                Text(
                  'A guide on how you can use Miloca to track your favourite places',
                  style: KTextStyle.descriptionTealText,
                ),
              ],
            ),
          ),
        ),
        Card(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('My Favourite Places', style: KTextStyle.titleTealText),
                Text(
                  'List of places that you have mark in Miloca',
                  style: KTextStyle.descriptionTealText,
                ),
              ],
            ),
          ),
        ),
        Card(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Go to map', style: KTextStyle.titleTealText),
                Text(
                  'Start using the map!',
                  style: KTextStyle.descriptionTealText,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
