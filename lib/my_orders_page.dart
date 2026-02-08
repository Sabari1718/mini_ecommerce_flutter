
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'orders_provider.dart';

class MyOrdersPage extends StatelessWidget {
  MyOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final orders = ordersProvider.orders;

    return Scaffold(
      appBar: AppBar(
        title:  Text(
          "My Orders",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        iconTheme: IconThemeData(color: Colors.black),
      ),

      body: orders.isEmpty
          ?  Center(
        child: Text(
          "No orders yet",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding:  EdgeInsets.all(12),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final p = orders[index];

          return Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding:
              EdgeInsets.symmetric(horizontal: 12, vertical: 10),

              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  p.thumbnail,
                  width: 55,
                  height: 55,
                  fit: BoxFit.cover,
                ),
              ),

              title: Text(
                p.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:  TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 15),
              ),

              subtitle: Text(
                "₹${p.price}",
                style:  TextStyle(
                    color: Colors.green,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),

              trailing: TextButton(
                onPressed: () {
                  ordersProvider.cancelOrder(p);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Order cancelled"),
                      duration: Duration(milliseconds: 800),
                    ),
                  );
                },
                child:  Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
