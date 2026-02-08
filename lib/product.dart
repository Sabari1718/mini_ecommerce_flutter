class Product {
  final int id;
  final String title;
  final String description;
  final num price;
  final num rating;
  final String thumbnail;
  final List<dynamic> images;
  final String category;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.rating,
    required this.thumbnail,
    required this.images,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> j) {
    return Product(
      id: j['id'],
      title: j['title'] ?? '',
      description: j['description'] ?? '',
      price: j['price'],
      rating: j['rating'],
      thumbnail: j['thumbnail'],
      images: j['images'] ?? [],
      category: j['category'] ?? '',
    );
  }

  get stock => null;
}