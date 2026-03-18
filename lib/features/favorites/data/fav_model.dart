class FavoriteItem {
  final int id;
  final String title;
  final String image;
  final double price;

  FavoriteItem({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'thumbnail': image, 'price': price};
  }

  factory FavoriteItem.fromMap(Map map) {
    return FavoriteItem(
      id: map['id'],
      title: map['title'],
      image: map['thumbnail'],
      price: map['price'],
    );
  }
}
