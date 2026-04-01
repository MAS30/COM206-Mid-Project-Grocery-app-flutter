import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GroceryScreen(),
    );
  }
}

class GroceryScreen extends StatefulWidget {
  @override
  _GroceryScreenState createState() => _GroceryScreenState();
}

class _GroceryScreenState extends State<GroceryScreen> {

  List<Map<String, dynamic>> allProducts = [
    {"name": "Apple", "price": 5, "category": "Fruits", "qty": 1},
    {"name": "Banana", "price": 4, "category": "Fruits", "qty": 1},
    {"name": "Carrot", "price": 3, "category": "Vegetables", "qty": 1},
    {"name": "Potato", "price": 2, "category": "Vegetables", "qty": 1},
    {"name": "Milk", "price": 6, "category": "Dairy", "qty": 1},
    {"name": "Cheese", "price": 8, "category": "Dairy", "qty": 1},
  ];

  String selectedCategory = "Fruits";
  List<Map<String, dynamic>> cart = [];

  int get total {
    int sum = 0;
    for (var item in cart) {
      sum += item["price"] * item["qty"] as int;
    }
    return sum;
  }

  int get totalItems {
    int count = 0;
    for (var item in cart) {
      count += item["qty"] as int;
    }
    return count;
  }

  void showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(bottom: 80, left: 20, right: 20),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void addToCart(Map<String, dynamic> product) {
    int index = cart.indexWhere((item) => item["name"] == product["name"]);

    setState(() {
      if (index != -1) {
        cart[index]["qty"] += product["qty"];
      } else {
        cart.add({
          "name": product["name"],
          "price": product["price"],
          "qty": product["qty"]
        });
      }
    });

    showMessage("${product["name"]} added");
  }

  void removeFromCart(String name) {
    setState(() {
      cart.removeWhere((item) => item["name"] == name);
    });
  }

  void decreaseCartItem(String name) {
    int index = cart.indexWhere((item) => item["name"] == name);

    setState(() {
      if (cart[index]["qty"] > 1) {
        cart[index]["qty"]--;
      } else {
        cart.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    var filtered = allProducts
        .where((item) => item["category"] == selectedCategory)
        .toList();

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Smart Grocery Cart"),
        actions: [
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(12),
                child: Icon(Icons.shopping_cart),
              ),
              if (totalItems > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      "$totalItems",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                )
            ],
          )
        ],
      ),

      body: Column(
        children: [

          // CATEGORY
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                ChoiceChip(
                  label: Text("Fruits"),
                  selected: selectedCategory == "Fruits",
                  selectedColor: Colors.orange,
                  onSelected: (_) => setState(() => selectedCategory = "Fruits"),
                ),

                ChoiceChip(
                  label: Text("Vegetables"),
                  selected: selectedCategory == "Vegetables",
                  selectedColor: Colors.orange,
                  onSelected: (_) => setState(() => selectedCategory = "Vegetables"),
                ),

                ChoiceChip(
                  label: Text("Dairy"),
                  selected: selectedCategory == "Dairy",
                  selectedColor: Colors.orange,
                  onSelected: (_) => setState(() => selectedCategory = "Dairy"),
                ),
              ],
            ),
          ),

          // PRODUCTS
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {

                var item = filtered[index];

                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(item["name"]),
                    subtitle: Text("Price: \$${item["price"]}"),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              if (item["qty"] > 1) item["qty"]--;
                            });
                          },
                        ),

                        Text("${item["qty"]}"),

                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              item["qty"]++;
                            });
                          },
                        ),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                          child: Text("Add"),
                          onPressed: () => addToCart(item),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // CART SECTION
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(top: BorderSide(color: Colors.grey)),
            ),
            child: Column(
              children: [

                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text("Your Cart",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),

                Divider(),

                Expanded(
                  child: ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {

                      var item = cart[index];

                      return ListTile(
                        dense: true,
                        title: Text("${item["name"]} (x${item["qty"]})"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            IconButton(
                              icon: Icon(Icons.remove, size: 18),
                              onPressed: () =>
                                  decreaseCartItem(item["name"]),
                            ),

                            IconButton(
                              icon: Icon(Icons.delete, size: 18),
                              onPressed: () =>
                                  removeFromCart(item["name"]),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // TOTAL
          Container(
            padding: EdgeInsets.all(15),
            color: Colors.orange[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total: \$${total}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: Text("Checkout"),
                  onPressed: () {
                    showMessage("Checkout complete");
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}