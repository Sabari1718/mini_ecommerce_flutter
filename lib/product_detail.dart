// lib/product_detail.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import 'cardpage.dart';
import 'order_success_page.dart';
import 'orders_provider.dart';
import 'product_service.dart';
import 'product.dart';
import 'cart_provider.dart';
import 'cart_page.dart';

class ProductDetailPage extends StatefulWidget {
  final int productId;

  ProductDetailPage({required this.productId, Key? key}) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final service = ProductService();
  Product? product;
  bool loading = true;


  List<Product> similar = [];
  bool loadingSimilar = false;


  final TextEditingController pincodeController = TextEditingController();
  String? pincodeResult;

  @override
  void initState() {
    super.initState();
    loadProduct();
  }

  @override
  void dispose() {
    pincodeController.dispose();
    super.dispose();
  }

  Future<void> loadProduct() async {
    setState(() => loading = true);
    try {
      product = await service.fetchSingleProduct(widget.productId);

      if (product != null && (product!.category.isNotEmpty)) {
        await loadSimilar(product!.category);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> loadSimilar(String category) async {
    setState(() => loadingSimilar = true);
    try {
      similar = await service.fetchProductsByCategory(category);

      similar.removeWhere((p) => p.id == widget.productId);
    } catch (e) {

    } finally {
      setState(() => loadingSimilar = false);
    }
  }


  void checkPincode() {
    final pin = pincodeController.text.trim();
    if (pin.length != 6 || int.tryParse(pin) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid 6-digit pincode")),
      );
      return;
    }


    String message;
    if (pin.startsWith('6')) {
      message = "✅ Delivery available — estimated 2 days";
    } else if (pin.startsWith('5')) {
      message = "✅ Delivery available — estimated 3 days";
    } else {
      message = "✅ Delivery available — estimated 4-7 days";
    }

    setState(() => pincodeResult = message);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget buildHighlights(Product p) {

    final highlights = <String>[
      "Top rated: ${p.rating}",
      "Category: ${p.category}",
      "Images: ${p.images.length}",

    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: highlights
          .map((h) => Chip(
        backgroundColor: Colors.deepPurple.withOpacity(.08),
        label: Text(
          h,
          style:  TextStyle(fontSize: 13, color: Colors.black87),
        ),
      ))
          .toList(),
    );
  }

  Widget buildSpecifications(Product p) {
    final specs = <MapEntry<String, String>>[
      MapEntry('Product ID', p.id.toString()),
      MapEntry('Category', p.category),
      MapEntry('Price', "₹${p.price}"),
      MapEntry('Rating', p.rating.toString()),
      MapEntry('Images', p.images.length.toString()),

    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding:  EdgeInsets.all(12),
      child: Column(
        children: specs
            .map((e) => Padding(
          padding:  EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  e.key,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ),
              Expanded(
                flex: 5,
                child: Text(
                  e.value,
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.black87),
                ),
              ),
            ],
          ),
        ))
            .toList(),
      ),
    );
  }

  Widget buildSimilarCarousel() {
    if (loadingSimilar) {
      return  SizedBox(
          height: 130, child: Center(child: CircularProgressIndicator()));
    }
    if (similar.isEmpty) {
      return  SizedBox(
        height: 120,
        child: Center(child: Text("No similar products found")),
      );
    }

    return SizedBox(
      height: 140,
      child: ListView.separated(
        padding:  EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: similar.length,
        separatorBuilder: (_, __) =>  SizedBox(width: 12),
        itemBuilder: (context, index) {
          final s = similar[index];
          return GestureDetector(
            onTap: () {

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetailPage(productId: s.id),
                ),
              );
            },
            child: Container(
              width: 110,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(.04),
                      blurRadius: 6,
                      offset:  Offset(0, 2))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 1.6 / 1,
                    child: ClipRRect(
                      borderRadius:  BorderRadius.vertical(top: Radius.circular(10)),
                      child: CachedNetworkImage(
                        imageUrl: s.thumbnail,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.all(8.0),
                    child: Text(
                      s.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:  TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title:  Text(
          "Product Details",
          style: TextStyle(color: Colors.black87),
        ),
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      body: loading
          ?  Center(child: CircularProgressIndicator())
          : product == null
          ?  Center(child: Text("Product not found"))
          : Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Stack(
                    children: [
                      Container(
                        color: Colors.grey.shade100,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: CachedNetworkImage(
                            imageUrl: product!.thumbnail,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 12,
                        bottom: 12,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(.12), blurRadius: 6),
                            ],
                          ),
                          child: Row(
                            children: [
                              Text(
                                "${product!.rating}",
                                style:  TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                               SizedBox(width: 4),
                               Icon(Icons.star, color: Colors.green, size: 16),
                               SizedBox(width: 6),
                              Text(

                                "${(product!.images.length * 10)}+ ratings",
                                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 12),


                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      product!.title,
                      style:  TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                  ),

                  SizedBox(height: 8),


                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Text(
                          "₹${product!.price}",
                          style:TextStyle(color: Colors.green, fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                         SizedBox(width: 12),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.orange.shade100, borderRadius: BorderRadius.circular(6)),
                          child:  Text("Special Price", style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),


                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 16),
                    child:  Text("Highlights", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  ),
                   SizedBox(height: 8),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 16),
                    child: buildHighlights(product!),
                  ),

                  SizedBox(height: 20),

                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 16),
                    child:  Text("Available Colors", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  ),
                   SizedBox(height: 8),
                  SizedBox(
                    height: 90,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding:  EdgeInsets.symmetric(horizontal: 16),
                      itemCount: product!.images.length,
                      itemBuilder: (context, i) {
                        final img = product!.images[i];
                        return Container(
                          margin: EdgeInsets.only(right: 12),
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.deepPurple.withOpacity(.25)),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(imageUrl: img, fit: BoxFit.cover),
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 20),


                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 16),
                    child:  Text("Ratings & Reviews", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  ),
                   SizedBox(height: 8),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("★ ${product!.rating} (approx)"),
                         SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.circle, size: 8),
                            SizedBox(width: 6),
                            Expanded(child: Text("Good product")),
                          ],
                        ),
                        SizedBox(height: 6),
                        Row(
                          children:  [
                            Icon(Icons.circle, size: 8),
                            SizedBox(width: 6),
                            Expanded(child: Text("Value for money")),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),


                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 16),
                    child: Text(product!.description, style:  TextStyle(fontSize: 15, height: 1.4)),
                  ),

                  SizedBox(height: 20),


                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 16),
                    child:  Text("Specifications", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 16),
                    child: buildSpecifications(product!),
                  ),

                   SizedBox(height: 20),


                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 16),
                    child:  Text("Delivery", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: pincodeController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "Enter pincode",
                              contentPadding:  EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.deepPurple),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                         SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: checkPincode,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellowAccent,
                            padding:  EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          ),
                          child:  Text("Check"),
                        )
                      ],
                    ),
                  ),
                  if (pincodeResult != null)
                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Text(pincodeResult!, style:  TextStyle(color: Colors.green)),
                    ),

                 SizedBox(height: 12),


                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 16),
                    child:  Text("Similar Products", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  ),
                   SizedBox(height: 12),
                  buildSimilarCarousel(),
                   SizedBox(height: 30),
                ],
              ),
            ),
          ),


          Container(
            padding:  EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(.1), blurRadius: 8, offset:  Offset(0, -2))],
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      cart.add(product!);
                      ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(content: Text("Added to cart"), duration: Duration(milliseconds: 800)),
                      );
                    },
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(color: Colors.orange.shade600, borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text("ADD TO CART", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17)),
                      ),
                    ),
                  ),
                ),
                 SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      final orders = Provider.of<OrdersProvider>(context, listen: false);


                      orders.addOrder(product!);


                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OrderSuccessPage(title: product!.title),
                        ),
                      );
                    },

                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(color:  Color(0xFFFFC600), borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text("BUY NOW", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 17)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

