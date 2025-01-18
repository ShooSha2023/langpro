import 'dart:ui';

class Store {
  int id;
  String name;
  String address;
  String contact;
  String? photo;
  String description;
  String? category;

  Store({
    required this.id,
    required this.name,
    required this.address,
    required this.contact,
    required this.photo,
    required this.description,
    required this.category,
  });
  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      contact: json['contact'],
      photo: json['photo'],
      description: json['description'],
      category: json['category'],
    );
  }
}

// final List<Store> stores = [
//   Store(
//     id: 1,
//     name: "Tech Store",
//     address: "123 Tech Street",
//     contact: "123-456-7890",
//   ),
//   Store(
//     id: 2,
//     name: "Fashion Store",
//     address: "456 Fashion Avenue",
//     contactInfo: "987-654-3210",
//   ),
//   Store(
//     id: 3,
//     name: "Plants store",
//     address: "123 demashk Street",
//     contactInfo: "123-456-7890",
//   )
// ];
