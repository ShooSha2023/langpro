class Store {
  int id;
  String name;
  String address;
  String contactInfo;

  Store({
    required this.id,
    required this.name,
    required this.address,
    required this.contactInfo,
  });
}

final List<Store> stores = [
  Store(
    id: 1,
    name: "Tech Store",
    address: "123 Tech Street",
    contactInfo: "123-456-7890",
  ),
  Store(
    id: 2,
    name: "Fashion Store",
    address: "456 Fashion Avenue",
    contactInfo: "987-654-3210",
  ),
  Store(
    id: 3,
    name: "Plants store",
    address: "123 demashk Street",
    contactInfo: "123-456-7890",
  )
];
