
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import 'cardpage.dart';
import 'my_orders_page.dart';
import 'product.dart';
import 'product_service.dart';
import 'cart_provider.dart';
import 'cart_page.dart';
import 'product_detail.dart';
import 'wishlist_page.dart';
import 'categories_page.dart';
import 'product_data.dart';

class ProductListPage extends StatefulWidget {
  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final service = ProductService();
  List<Product> products = [];
  bool loading = true;

  String selectedSort = "none";
  int _selectedBottom = 0;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    setState(() => loading = true);
    try {
      products = await service.fetchProducts(limit: 30);
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> applySorting() async {
    if (selectedSort == "none") {
      await load();
      return;
    }

    String field = selectedSort.contains("title") ? "title" : "price";
    String order = selectedSort.contains("asc") ? "asc" : "desc";

    products = await service.sortProducts(sortBy: field, order: order);
    setState(() {});
  }

  InputDecoration stylishBox(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.black.withOpacity(.45)),
      prefixIcon: Icon(icon, color: Colors.deepPurple),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.deepPurple.withOpacity(.25)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.deepPurple, width: 1.4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xffeef0fd),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: Row(
          children: [
            Text("🛍️", style: TextStyle(fontSize: 26)),
            SizedBox(width: 10),
            Text(
              "Mini Ecom",
              style: TextStyle(
                fontSize: 22,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => CartPage()));
            },
            icon: Stack(
              children: [
                Icon(Icons.shopping_cart, size: 26, color: Colors.black87),
                if (cart.items.isNotEmpty)
                  Positioned(
                    right: 0,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,
                      child: Text(
                        "${cart.items.length}",
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),

      body: loading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: load,
        child: Column(
          children: [
            SizedBox(height: 10),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: TextField(
                decoration:
                stylishBox("Search products…", Icons.search),
                onChanged: (value) async {
                  if (value.trim().isEmpty) {
                    load();
                  } else {
                    products =
                    await service.searchProducts(value.trim());
                    setState(() {});
                  }
                },
              ),
            ),

            SizedBox(height: 10),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: DropdownButtonFormField<String>(
                value: selectedSort,
                decoration: stylishBox(
                    "Sort products…", Icons.filter_list_rounded),
                items: [
                  DropdownMenuItem(
                      value: "none", child: Text("Sort: None")),
                  DropdownMenuItem(
                      value: "title_asc",
                      child: Text("Title A → Z")),
                  DropdownMenuItem(
                      value: "title_desc",
                      child: Text("Title Z → A")),
                  DropdownMenuItem(
                      value: "price_asc",
                      child: Text("Price Low → High")),
                  DropdownMenuItem(
                      value: "price_desc",
                      child: Text("Price High → Low")),
                ],
                onChanged: (val) async {
                  selectedSort = val!;
                  applySorting();
                },
              ),
            ),

            SizedBox(height: 10),

            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(12),
                gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.70,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final p = products[index];


                  final productMap = {
                    'id': p.id,
                    'title': p.title,
                    'image': p.thumbnail,
                    'price': p.price
                  };

                  final isFav = isFavourite(productMap);

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.08),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProductDetailPage(
                                    productId: p.id),
                              ),
                            );
                          },
                          child: Container(
                            height: 100,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16)),
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    p.thumbnail),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            p.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14),
                          ),
                        ),

                        Padding(
                          padding:
                          EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            "₹${p.price}",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                        ),

                        Spacer(),

                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  cart.add(p);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                      content:
                                      Text("Added to cart")));
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color:
                                    Colors.deepPurple.shade50,
                                    borderRadius:
                                    BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.add_shopping_cart,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                              ),


                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isFav
                                        ? removeFromFavourite(
                                        productMap)
                                        : addToFavourite(productMap);
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.pink.shade50,
                                    borderRadius:
                                    BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    isFav
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isFav
                                        ? Colors.red
                                        : Colors.pink,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 4),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedBottom,
        onTap: (index) {
          setState(() => _selectedBottom = index);

          if (index == 1) {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => WishlistPage(favorites: [],)));
          }

          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => CategoriesPage(products: products)),
            );
          }

          if (index == 3) {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => MyOrdersPage()));
          }

          if (index == 4) {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => CartPage()));
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border), label: "Favourite"),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_mall_outlined), label: "Categories"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: "Account"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined), label: "Cart"),
        ],
      ),
    );
  }
}
