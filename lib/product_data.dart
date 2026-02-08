final List<Map<String, dynamic>> allProducts = [
  {
    'id': 'm1',
    'title': 'iPhone 15 Pro',
    'image': 'https://images.unsplash.com/photo-1695059792175-21c8a6c46b90?w=800',
    'price': 129900,
    'rating': 4.8,
    'category': 'mobiles',
    'description': 'Apple iPhone 15 Pro with A17 Pro chip and titanium body.'
  },
  {
    'id': 'm2',
    'title': 'Samsung Galaxy S24 Ultra',
    'image': 'https://images.unsplash.com/photo-1705423118920-d6f52c16e491?w=800',
    'price': 109999,
    'rating': 4.7,
    'category': 'mobiles',
    'description': 'Samsung S24 Ultra with 200MP camera and AI features.'
  },
  {
    'id': 'm3',
    'title': 'Vivo V30',
    'image': 'https://images.unsplash.com/photo-1587825140708-74d7a7d2293f?w=800',
    'price': 32999,
    'rating': 4.4,
    'category': 'mobiles',
    'description': 'Vivo V30 with AMOLED display and fast charging.'
  },
  {
    'id': 'f1',
    'title': 'Men\'s Cotton T-Shirt',
    'image': 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=800',
    'price': 599,
    'rating': 4.2,
    'category': 'fashion',
    'description': 'Premium cotton round-neck T-shirt.'
  },
  {
    'id': 'f2',
    'title': 'Slim Fit Jeans',
    'image': 'https://images.unsplash.com/photo-1587583779034-3a1d6e8bb2cb?w=800',
    'price': 1299,
    'rating': 4.3,
    'category': 'fashion',
    'description': 'Stretchable slim-fit blue jeans.'
  },
  {
    'id': 'f3',
    'title': 'Running Shoes',
    'image': 'https://images.unsplash.com/photo-1528701800489-20be3c482d5c?w=800',
    'price': 2499,
    'rating': 4.5,
    'category': 'fashion',
    'description': 'Breathable and lightweight running shoes.'
  },
  {
    'id': 's1',
    'title': 'MRF Cricket Bat',
    'image': 'https://images.unsplash.com/photo-1611333168044-39a147c75b2a?w=800',
    'price': 4999,
    'rating': 4.6,
    'category': 'sports',
    'description': 'Premium English willow MRF cricket bat.'
  },
  {
    'id': 's2',
    'title': 'Adidas Football',
    'image': 'https://images.unsplash.com/photo-1508804197766-cb4650c3d22c?w=800',
    'price': 899,
    'rating': 4.4,
    'category': 'sports',
    'description': 'Original Adidas football with textured grip.'
  },
  {
    'id': 'e1',
    'title': 'MacBook Air M2',
    'image': 'https://images.unsplash.com/photo-1674121358690-39fce968d2ad?w=800',
    'price': 97990,
    'rating': 4.8,
    'category': 'electronics',
    'description': 'Apple MacBook Air M2 with Retina display.'
  },
  {
    'id': 'e2',
    'title': 'Sony WH-1000XM5 Headphones',
    'image': 'https://images.unsplash.com/photo-1600185365483-26d2c231fafd?w=800',
    'price': 29999,
    'rating': 4.7,
    'category': 'electronics',
    'description': 'Industry-leading noise cancellation headphones.'
  },
  {
    'id': 'b1',
    'title': 'Dove Shampoo',
    'image': 'https://images.unsplash.com/photo-1604917877931-48e3a65cefc2?w=800',
    'price': 349,
    'rating': 4.3,
    'category': 'beauty',
    'description': 'Anti-dandruff Dove shampoo with conditioner.'
  },
  {
    'id': 'b2',
    'title': 'Luxury Perfume',
    'image': 'https://images.unsplash.com/photo-1600180758890-6f8c43f46380?w=800',
    'price': 1899,
    'rating': 4.5,
    'category': 'beauty',
    'description': 'Long-lasting premium fragrance.'
  },
];



final List<Map<String, dynamic>> cartItems = [];

void addToCart(Map<String, dynamic> product) => cartItems.add(product);
void removeFromCart(Map<String, dynamic> product) => cartItems.remove(product);
void removeAtIndex(int index) => cartItems.removeAt(index);

double cartTotal() {
  return cartItems.fold(
      0, (sum, item) => sum + (item['price'] as num).toDouble());
}



final List<Map<String, dynamic>> favouriteProducts = [];

bool isFavourite(Map<String, dynamic> product) {
  return favouriteProducts.any((p) => p['id'] == product['id']);
}

void addToFavourite(Map<String, dynamic> product) {
  if (!isFavourite(product)) {
    favouriteProducts.add(product);
  }
}

void removeFromFavourite(Map<String, dynamic> product) {
  favouriteProducts.removeWhere((p) => p['id'] == product['id']);
}