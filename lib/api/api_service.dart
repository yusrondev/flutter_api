import 'dart:io';

import 'package:flutter_api/models/product.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {

  String? apiUrl = dotenv.env['API_URL'];
  String? apiUrlProduct = dotenv.env['API_PRODUCT'];
  String? bearerToken = dotenv.env['BEARER_TOKEN'];
  String? apiToken = dotenv.env['API_TOKEN'];

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(
      Uri.parse(apiUrl!),
      headers: {'Authorization': 'Bearer $bearerToken', 'X-API-TOKEN' : apiToken!},
    );
    if (response.statusCode == 200) {
      List data = json.decode(response.body)['products'];
      return data.map((json) => Product.fromJson(json)).toList();
    }
    return [];
  }

  Future<bool> createProduct(String name, String price, File? imageFile, String shortDescription) async {
    var request = http.MultipartRequest('POST', Uri.parse(apiUrlProduct!));
    request.headers['Authorization'] = 'Bearer $bearerToken';
    request.headers['X-API-TOKEN'] = apiToken!;
    request.fields['name'] = name;
    request.fields['price'] = price;
    request.fields['short_description'] = shortDescription;
    
    if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
    }
    
    var response = await request.send();
    return response.statusCode == 200;
  }

  Future<bool> updateProduct(int id, String name, String price, File? imageFile, String shortDescription) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('${apiUrlProduct!}/$id'));
      request.headers['Authorization'] = 'Bearer $bearerToken';
      request.headers['X-API-TOKEN'] = apiToken!;
      request.fields['name'] = name;
      request.fields['price'] = price;
      request.fields['short_description'] = shortDescription;

      if (imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
      }

      var response = await request.send();
      if (response.statusCode == 200) {
        return response.statusCode == 200;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> findProduct(int id) async {
    try {
      var request = http.MultipartRequest('GET', Uri.parse('${apiUrlProduct!}/$id'));
      request.headers['Authorization'] = 'Bearer $bearerToken';
      request.headers['X-API-TOKEN'] = apiToken!;

      final response = await request.send();

      if (response.statusCode == 200) {
        json.decode(response.body);
        print(response);
      }
        return true;

    } catch (e) {
      return false;
    }
  }
}