
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_provider.dart';
import 'orders_provider.dart';
import 'homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ProductListPage(),
      ),
    );
  }
}
