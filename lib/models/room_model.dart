class RoomModel {
  final String id;
  final String kostId;
  final String name;
  final double price;
  final String description;
  final bool isAvailable;

  RoomModel({
    required this.id,
    required this.kostId,
    required this.name,
    required this.price,
    required this.description,
    required this.isAvailable,
  });

  factory RoomModel.fromMap(Map<String, dynamic> map) {
    return RoomModel(
      id: map['id'],
      kostId: map['kostId'],
      name: map['name'],
      price: map['price'].toDouble(),
      description: map['description'],
      isAvailable: map['isAvailable'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'kostId': kostId,
      'name': name,
      'price': price,
      'description': description,
      'isAvailable': isAvailable,
    };
  }
}
