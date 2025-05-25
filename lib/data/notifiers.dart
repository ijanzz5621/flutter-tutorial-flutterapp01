// ValueNotifier: hold the data
// ValueListenableBuilder : listen to the changes in the data

import 'package:flutter/material.dart';

ValueNotifier<int> selectedPageNotifier = ValueNotifier(0);
ValueNotifier<bool> isDarkModeNotifier = ValueNotifier(true);
