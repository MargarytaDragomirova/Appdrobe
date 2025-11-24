import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/cloth.dart';
import '../models/outfit.dart';

class ApiService {
  static const String baseUrl = "http://192.168.1.7:5269";

  // ================= CLOTHES =================

  // GET all clothes
  static Future<List<Cloth>> getClothes() async {
    final response = await http.get(Uri.parse("$baseUrl/Home/GetClothes"));
    if (response.statusCode == 200) {
      List list = jsonDecode(response.body);
      return list.map((e) => Cloth.fromJson(e)).toList();
    }
    throw Exception("Failed to load clothes");
  }

  // GET clothes with filters
  static Future<List<Cloth>> filterClothes({
    String? category,
    String? color,
    String? season,
    String? location,
  }) async {
    final uri = Uri.parse("$baseUrl/Home/FilterClothes").replace(
      queryParameters: {
        if (category != null) 'category': category,
        if (color != null) 'color': color,
        if (season != null) 'season': season,
        if (location != null) 'location': location,
      },
    );

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      List list = jsonDecode(response.body);
      return list.map((e) => Cloth.fromJson(e)).toList();
    }
    throw Exception("Failed to filter clothes");
  }

  // DELETE cloth
  static Future<void> deleteCloth(int id) async {
    await http.delete(Uri.parse("$baseUrl/Home/DeleteCloth?id=$id"));
  }

  // CREATE cloth with images
  static Future<bool> createCloth({
    required String name,
    required String category,
    required String color,
    required String season,
    required String location,
    required List<File> images,
  }) async {
    final uri = Uri.parse("$baseUrl/Home/CreateCloth");
    var request = http.MultipartRequest("POST", uri);

    request.fields["Name"] = name;
    request.fields["Category"] = category;
    request.fields["Color"] = color;
    request.fields["Season"] = season;
    request.fields["Location"] = location;

    for (var img in images) {
      request.files.add(
        await http.MultipartFile.fromPath("imageFiles", img.path),
      );
    }

    var response = await request.send();
    return response.statusCode == 200;
  }

  // ================= OUTFITS =================

  // GET all outfits
  // GET all outfits
  static Future<List<Outfit>> getOutfits() async {
    final response = await http.get(Uri.parse("$baseUrl/Home/GetOutfits"));
    if (response.statusCode == 200) {
      List list = jsonDecode(response.body);
      return list.map((e) => Outfit.fromJson(e)).toList();
    }
    throw Exception("Failed to load outfits");
  }

  // GET single outfit by id
  static Future<Outfit> getOutfit(int id) async {
    final response = await http.get(Uri.parse("$baseUrl/Home/GetOutfit/$id"));
    if (response.statusCode == 200) {
      return Outfit.fromJson(jsonDecode(response.body));
    }
    throw Exception("Outfit not found");
  }

  // CREATE outfit
  static Future<bool> createOutfit({
    required String name,
    required List<int> clothIds,
  }) async {
    final uri = Uri.parse("$baseUrl/Home/CreateOutfitApi");

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"name": name, "clothIds": clothIds}),
    );

    return response.statusCode == 200;
  }

  // DELETE outfit
  static Future<void> deleteOutfit(int id) async {
    await http.delete(Uri.parse("$baseUrl/Home/DeleteOutfitApi/$id"));
  }
}
