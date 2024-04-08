import 'package:flutter/material.dart';
import 'package:tech_case_18/screens/ingredients_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: IngredientsScreen(),
    );
  }
}
