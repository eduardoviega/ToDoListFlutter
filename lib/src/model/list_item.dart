import 'dart:convert';

class Item {
  int id;
  String name;
  bool isChecked = false;

  Item({this.id = 0, required this.isChecked, required this.name});

  factory Item.fromJson(Map<String, dynamic> map) {
    return Item(id: map["id"], name: map["name"], isChecked: map["is_checked"]);
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "isChecked": isChecked};
  }

  @override
  String toString() {
    return 'Item{id: $id, name: $name, isChecked: $isChecked}';
  }
}

List<Item> itemFromJson(List<dynamic> data) {
  return List<Item>.from(
    data.map((item) => Item.fromJson(item)),
  );
}

String itemToJson(Item data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
