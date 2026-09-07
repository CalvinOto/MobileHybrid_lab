class Purchase {
  final int id;
  final int userId;
  final int resourceId;
  final int quantity;
  final double totalPrice;
  final String purchasedAt;
  final String? name;
  final String? image;
  final String? type;

  Purchase({
    required this.id,
    required this.userId,
    required this.resourceId,
    required this.quantity,
    required this.totalPrice,
    required this.purchasedAt,
    this.name,
    this.image,
    this.type,
  });

  factory Purchase.fromJson(Map<String, dynamic> json) => Purchase(
    id: json['id'],
    userId: json['user_id'],
    resourceId: json['resource_id'],
    quantity: json['quantity'],
    totalPrice: double.parse(json['total_price'].toString()),
    purchasedAt: json['purchased_at'] ?? '',
    name: json['name'],
    image: json['image'],
    type: json['type'],
  );
}