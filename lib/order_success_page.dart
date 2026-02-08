import 'package:flutter/material.dart';
import 'my_orders_page.dart';

class OrderSuccessPage extends StatelessWidget {
  final String title;

  OrderSuccessPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding:  EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_rounded,
                  size: 90, color: Colors.green),
              SizedBox(height: 20),

              Text(
                "Order Placed Successfully!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10),

              Text(
                title,
                style:  TextStyle(fontSize: 18, color: Colors.black54),
              ),

              SizedBox(height: 40),

              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) =>  MyOrdersPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:  EdgeInsets.symmetric(
                      horizontal: 40, vertical: 14),
                ),
                child:  Text(
                  "View My Orders",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}