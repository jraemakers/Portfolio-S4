import 'package:flutter/material.dart';
import 'package:tech_case_18/widgets/pizza_painter.dart';

class PizzaScreen extends StatelessWidget {
  final List<String> ingredients;

  const PizzaScreen({super.key, required this.ingredients});

  Map<String, int> getFibonacciIngredients() {
    final fibonacciNumbers = [1, 1];
    for (int i = 2; i < ingredients.length; i++) {
      fibonacciNumbers.add(fibonacciNumbers[i - 1] + fibonacciNumbers[i - 2]);
    }

    Map<String, int> fibonacciIngredients = {};
    for (int i = 0; i < ingredients.length; i++) {
      fibonacciIngredients[ingredients[i]] = fibonacciNumbers[i];
    }

    return fibonacciIngredients;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, int> ingredientsWithFibonacci = getFibonacciIngredients();

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
                painter: PizzaPainter(ingredients: ingredientsWithFibonacci),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: ingredients.length,
              itemBuilder: (context, index) {
                String ingredient = ingredients[index];
                int amount = ingredientsWithFibonacci[ingredient] ?? 0;
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
