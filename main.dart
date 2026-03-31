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

  List<Map<String, dynamic>> products = [
    {"name": "Apple", "price": 5, "qty": 1},
    {"name": "Milk", "price": 3, "qty": 1},
    {"name": "Bread", "price": 2, "qty": 1},
  ];

  int get total {
    int sum = 0;
    for (var item in products) {
      sum += item["price"] * item["qty"] as int;
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("Grocery Cart"),
        actions: [
          Icon(Icons.shopping_cart),
          SizedBox(width: 20)
        ],
      ),

      body: Column(
        children: [

          // Categories
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Chip(label: Text("Fruits")),
                Chip(label: Text("Vegetables")),
                Chip(label: Text("Dairy")),
              ],
            ),
          ),

          // Product List
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                var item = products[index];

                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: Icon(Icons.image),
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
                          child: Text("Add"),
                          onPressed: () {},
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom Bar
          Container(
            padding: EdgeInsets.all(15),
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total: \$${total}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ElevatedButton(
                  child: Text("Checkout"),
                  onPressed: () {},
                )
              ],
            ),
          )
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: "Categories"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}