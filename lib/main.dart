import 'package:flutter/material.dart';
import 'package:spacenetic_flutter/UI/timeline_page.dart';

import 'UI/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
      //home: TimelineWidget(),
    );
  }
}
