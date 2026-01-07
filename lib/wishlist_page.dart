import 'package:flutter/material.dart';
import 'product.dart';

class WishlistPage extends StatefulWidget {
  final List<Product> favorites;

  WishlistPage({super.key, required this.favorites});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  List<Product> favList = [];

  @override
  void initState() {
    super.initState();
    favList = List.from(widget.favorites); // local copy
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xfff9f3ff),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title:  Text(
          "Wishlist",
          style: TextStyle(color: Colors.black),
        ),
      ),

      body: favList.isEmpty
          ?  Center(
        child: Text(
          "No favourites added",
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: favList.length,
        itemBuilder: (context, index) {
          final p = favList[index];

          return Dismissible(
            key: Key(p.id.toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20),
              color: Colors.red,
              child:  Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (_) {
              setState(() {
                favList.removeAt(index);
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("${p.title} removed")),
              );
            },

            child: ListTile(
              leading: Image.network(
                p.thumbnail,
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              ),
              title: Text(p.title),
              subtitle: Text("₹${p.price}"),

              trailing: IconButton(
                icon: Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () {
                  setState(() {
                    favList.removeAt(index);
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("${p.title} removed")),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
