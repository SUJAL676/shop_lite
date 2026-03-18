class ProductModel {
  final int id;
  final String title;
  final String description;
  final double price;
  final String thumbnail;
  final int rating;
  final String shippinginfo;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.thumbnail,
    required this.rating,
    required this.shippinginfo,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'thumbnail': thumbnail,
      'rating': rating,
      'shippingInformation': shippinginfo,
    };
  }

  factory ProductModel.fromJson(Map json) {
    double rating = json["rating"];

    return ProductModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'].toDouble(),
      thumbnail: json['thumbnail'],
      rating: rating.round(),
      shippinginfo: json["shippingInformation"],
    );
  }
}
