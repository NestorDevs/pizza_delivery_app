import 'dart:convert';

class MenuItemModel {
  final int id;
  final String name;
  final double price;

  MenuItemModel({
    this.id,
    this.name,
    this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }

  factory MenuItemModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return MenuItemModel(
      id: map['id'],
      name: map['name'],
      price: map['price'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MenuItemModel.fromJson(String source) =>
      MenuItemModel.fromMap(json.decode(source));

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is MenuItemModel &&
        o.id == id &&
        o.name == name &&
        o.price == price;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ price.hashCode;
}
