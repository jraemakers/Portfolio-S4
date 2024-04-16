import 'package:flutter/material.dart';
import 'package:tech_case_18/widgets/pizza_painter.dart';

class PizzaScreen extends StatelessWidget {
  final List<String> ingredients;

  const PizzaScreen({super.key, required this.ingredients});

  Map<String, int> generateFibonacciIngredients(List<String> ingredients) {
    Map<String, int> fibonacciIngredients = {};
    int a = 1, b = 1;

    for (int i = 0; i < ingredients.length; i++) {
      fibonacciIngredients[ingredients[i]] = a;
      int nextFib = a + b;
      a = b;
      b = nextFib;
    }

    return fibonacciIngredients;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, int> fibonacciIngredients =
        generateFibonacciIngredients(ingredients);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Fibonacci Pizza"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: CustomPaint(
                size: const Size(200, 200),
                painter: PizzaPainter(ingredients: fibonacciIngredients),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: ingredients.length,
              itemBuilder: (context, index) {
                String ingredient = ingredients[index];
                int amount = fibonacciIngredients[ingredient] ?? 0;
                Color color = Colors.primaries[index % Colors.primaries.length];
                return ListTile(
                  title: Text(ingredient),
                  trailing: Text('$amount'),
                  leading: Icon(Icons.circle, color: color),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
