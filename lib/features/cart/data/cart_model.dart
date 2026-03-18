class CartItem {
  final int id;
  final String title;
  final double price;
  final String image;
  int quantity;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    this.quantity = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'image': image,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map map) {
    return CartItem(
      id: map['id'],
      title: map['title'],
      price: map['price'],
      image: map['image'],
      quantity: map['quantity'],
    );
  }
}
