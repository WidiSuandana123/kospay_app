class KostModel {
  final String id;
  final String name;
  final String address;
  final String ownerId;
  final double price;
  final String description;

  KostModel({
    required this.id,
    required this.name,
    required this.address,
    required this.ownerId,
    required this.price,
    required this.description,
  });

  factory KostModel.fromMap(Map<String, dynamic> map) {
    return KostModel(
      id: map['id'],
      name: map['name'],
      address: map['address'],
      ownerId: map['ownerId'],
      price: map['price'].toDouble(),
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'ownerId': ownerId,
      'price': price,
      'description': description,
    };
  }
}
