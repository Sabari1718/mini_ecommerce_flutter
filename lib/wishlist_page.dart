
import 'package:flutter/material.dart';
import 'product_data.dart';

class WishlistPage extends StatefulWidget {
  WishlistPage({super.key, required List favorites});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  void handleRemove(Map<String, dynamic> product) {
    setState(() {
      removeFromFavourite(product); // Updates global list
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${product['title']} removed")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xfff9f3ff),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading:  BackButton(color: Colors.black),
        title:  Text(
          "Wishlist",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: favouriteProducts.isEmpty
          ?  Center(
        child: Text(
          "No favourites added",
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: favouriteProducts.length,
        itemBuilder: (context, index) {
          final p = favouriteProducts[index];

          return Dismissible(
            key: Key(p['id'].toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding:  EdgeInsets.only(right: 20),
              color: Colors.red,
              child:  Icon(Icons.delete, color: Colors.white, size: 26),
            ),
            onDismissed: (_) => handleRemove(p),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  p['image'],
                  height: 55,
                  width: 55,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                p['title'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:  TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                "₹${p['price']}",
                style:  TextStyle(
                    color: Colors.green, fontWeight: FontWeight.bold),
              ),
              trailing: GestureDetector(
                onTap: () => handleRemove(p),
                child: Container(
                  padding:  EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children:  [
                      Icon(Icons.favorite, color: Colors.red, size: 18),
                      SizedBox(width: 6),
                      Text("Remove", style: TextStyle(color: Colors.red)),
                    ],
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
