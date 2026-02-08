import 'dart:convert';
import 'package:http/http.dart' as http;
import 'product.dart';

class ProductService {
  static String base = "https://dummyjson.com";


  Future<List<Product>> fetchProducts({int limit = 30, int skip = 0}) async {
    final url = Uri.parse('$base/products?limit=$limit&skip=$skip');
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return (data['products'] as List)
          .map((e) => Product.fromJson(e))
          .toList();
    } else {
      throw Exception("Failed to load products");
    }
  }


  Future<Product> fetchSingleProduct(int id) async {
    final url = Uri.parse('$base/products/$id');
    final res = await http.get(url);

    if (res.statusCode == 200) {
      return Product.fromJson(jsonDecode(res.body));
    } else {
      throw Exception("Failed to load single product");
    }
  }


  Future<List<Product>> searchProducts(String query) async {
    final url = Uri.parse('$base/products/search?q=$query');
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return (data['products'] as List)
          .map((e) => Product.fromJson(e))
          .toList();
    } else {
      throw Exception("Search failed");
    }
  }

  Future<List<String>> fetchCategories() async {
    final url = Uri.parse('$base/products/categories');
    final res = await http.get(url);

    if (res.statusCode == 200) {
      return List<String>.from(jsonDecode(res.body));
    } else {
      throw Exception("Failed to load categories");
    }
  }


  Future<List<Product>> fetchProductsByCategory(String category) async {
    final url = Uri.parse('$base/products/category/$category');
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return (data['products'] as List)
          .map((e) => Product.fromJson(e))
          .toList();
    } else {
      throw Exception("Failed to load products of category");
    }
  }


  Future<List<Product>> fetchLimitedProducts({
    int limit = 10,
    int skip = 0,
  }) async {
    final url = Uri.parse(
      '$base/products?limit=$limit&skip=$skip&select=title,price,thumbnail',
    );

    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return (data['products'] as List)
          .map((e) => Product.fromJson(e))
          .toList();
    } else {
      throw Exception("Failed to load limited products");
    }
  }


  Future<List<Product>> sortProducts({
    String sortBy = "title",
    String order = "asc",
  }) async {
    final url = Uri.parse('$base/products?sortBy=$sortBy&order=$order');
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return (data['products'] as List)
          .map((e) => Product.fromJson(e))
          .toList();
    } else {
      throw Exception("Failed to sort products");
    }
  }
}