import 'package:flutter/material.dart';
import 'package:tech_case_18/screens/pizza_screen.dart';

class IngredientsScreen extends StatefulWidget {
  const IngredientsScreen({super.key});

  @override
  _IngredientsScreenState createState() => _IngredientsScreenState();
}

class _IngredientsScreenState extends State<IngredientsScreen> {
  List<Map<String, dynamic>> items = [
    {"name": "Mozzarella Cheese", "image": "mozzarella_cheese.jpg"},
    {"name": "Pepperoni", "image": "pepperoni.jpg"},
    {"name": "Tomato Sauce", "image": "tomato_sauce.jpg"},
    {"name": "Mushrooms", "image": "mushrooms.jpg"},
    {"name": "Italian Sausage", "image": "italian_sausage.jpg"},
    {"name": "Bell Peppers", "image": "bell_peppers.jpg"},
    {"name": "Onions", "image": "onions.jpg"},
    {"name": "Olives", "image": "olives.jpg"},
    {"name": "Fresh Basil", "image": "fresh_basil.jpg"},
    {"name": "Garlic", "image": "garlic.jpg"}
  ];

  List<Widget> itemTiles() {
    return items.asMap().entries.map((entry) {
      final int index = entry.key;
      final Map<String, dynamic> item = entry.value;
      return Dismissible(
        key: Key(item["name"]),
        onDismissed: (direction) {
          setState(() {
            items.removeAt(index);
          });
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("${item["name"]} dismissed")));
        },
        background: Container(color: Colors.red),
        child: ListTile(
          key: ValueKey(item["name"]),
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.drag_handle),
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundImage: AssetImage('assets/${item["image"]}'),
              ),
            ],
          ),
          title: Text(item["name"]),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              setState(() {
                items.removeAt(index);
              });
            },
          ),
        ),
      );
    }).toList();
  }

  void navigateToPizzaScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PizzaScreen(
          ingredients: items.map((item) => item["name"] as String).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Draggable Ingredient List"),
      ),
      body: ReorderableListView(
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) {
              newIndex -= 1;
            }
            final item = items.removeAt(oldIndex);
            items.insert(newIndex, item);
          });
        },
        children: itemTiles(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToPizzaScreen,
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
