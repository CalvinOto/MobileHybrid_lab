class Resource {
  final int id;
  final String name;
  final String type;
  final String description;
  final int stock;
  final String? image;
  final double price;

  Resource({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.stock,
    this.image,
    required this.price,
  });

  factory Resource.fromJson(Map<String, dynamic> json) => Resource(
    id: json['id'],
    name: json['name'],
    type: json['type'],
    description: json['description'] ?? '',
    stock: json['stock'],
    image: json['image'],
    price: double.parse(json['price'].toString()),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type,
    'description': description,
    'stock': stock,
    'image': image,
    'price': price,
  };
}