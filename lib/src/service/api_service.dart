import 'dart:convert';

import 'package:to_do_list/src/model/list_item.dart';
import 'package:http/http.dart' as http;
import 'api_url.dart';

class ApiService {

  Future<List<Item>> getItems() async {
    var url = Uri.parse('$apiUrl/getList');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      return itemFromJson(
        json.decode(utf8.decode(response.bodyBytes)),
      );
    }
    return [];
  }

  Future<bool> createItem(Item item) async {
    var url = Uri.parse('$apiUrl/addItem');
    final response = await http.post(
      url,
      headers: {"content-type": "application/json"},
      body: itemToJson(item),
    );
    return response.statusCode == 202;
  }

  Future<bool> updateItem(Item data) async {
    var url = Uri.parse('$apiUrl/checkItem');
    final response = await http.put(
      url,
      headers: {"content-type": "application/json"},
      body: itemToJson(data),
    );
    return response.statusCode == 200;
  }

  Future<bool> deleteItem(Item item) async {
    var url = Uri.parse('$apiUrl/delete');
    var tojsonitem = itemToJson(item);
    final response = await http.delete(
      url,
      headers: {"content-type": "application/json"},
      body: tojsonitem,
    );
    return response.statusCode == 202;
  }
}
