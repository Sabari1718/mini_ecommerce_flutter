import 'package:flutter/material.dart';
import 'product.dart';
import 'product_detail.dart';

class CategoriesPage extends StatefulWidget {
  final List<Product> products;

    CategoriesPage({super.key, required this.products});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {

    List<String> categories = widget.products
        .map((p) => p.category)
        .toSet()
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 3,
        title:   Text(
          "Categories",
          style: TextStyle(color: Colors.black),
        ),
      ),

      body: Column(
        children: [
            SizedBox(height: 10),


          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding:   EdgeInsets.symmetric(horizontal: 10),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                String cat = categories[index];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = cat;
                    });
                  },
                  child: Container(
                    margin:   EdgeInsets.only(right: 10),
                    padding:   EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: selectedCategory == cat
                          ? Colors.blue.shade100
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        cat.toUpperCase(),
                        style: TextStyle(
                          color: selectedCategory == cat
                              ? Colors.blue
                              : Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

            SizedBox(height: 10),


          Expanded(
            child: selectedCategory == null
                ?   Center(
              child: Text(
                "Select a category",
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w500),
              ),
            )
                : _buildCategoryProducts(),
          ),
        ],
      ),
    );
  }


  Widget _buildCategoryProducts() {
    final filtered = widget.products
        .where((p) => p.category == selectedCategory)
        .toList();

    return GridView.builder(
      padding:   EdgeInsets.all(12),
      gridDelegate:   SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.70,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final p = filtered[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailPage(productId: p.id),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.08),
                  blurRadius: 8,
                  offset:   Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius:  BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(p.thumbnail),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),


                Padding(
                  padding:  EdgeInsets.all(8),
                  child: Text(
                    p.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:  TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),


                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    "₹${p.price}",
                    style:  TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
