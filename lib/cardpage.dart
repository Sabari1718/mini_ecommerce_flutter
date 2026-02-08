
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Cart')),
      body: cart.items.isEmpty
          ? Center(child: Text('Cart is empty'))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, i) {
                final it = cart.items[i];
                return ListTile(
                  leading: Image.network(it.product.thumbnail, width: 60, fit: BoxFit.cover),
                  title: Text(it.product.title),
                  subtitle: Text('₹${it.product.price} x ${it.qty}'),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(icon: Icon(Icons.remove), onPressed: () => cart.changeQty(it.product, it.qty - 1)),
                    IconButton(icon: Icon(Icons.add), onPressed: () => cart.changeQty(it.product, it.qty + 1)),
                    IconButton(icon: Icon(Icons.delete), onPressed: () => cart.remove(it.product)),
                  ]),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                Text('Total: ₹${cart.total.toStringAsFixed(2)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {

                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('Checkout'),
                          content: Text('This is a demo checkout. Total ₹${cart.total.toStringAsFixed(2)}'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
                            TextButton(
                                onPressed: () {
                                  cart.clear();
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order placed (mock)')));
                                },
                                child: Text('Place Order'))
                          ],
                        ));
                  },
                  child: Text('Checkout'),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
