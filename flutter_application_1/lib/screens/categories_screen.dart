import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/cloth.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<Cloth> clothes = [];
  bool loading = true;
  String? selectedCategory;

  final List<String> categories = [
    "Jacket",
    "T-Shirt",
    "Shirt",
    "Pants",
    "Shorts",
    "Dress",
    "Skirt",
    "Sweater",
    "Coat",
    "Shoes",
    "Accessory",
  ];

  @override
  void initState() {
    super.initState();
    fetchClothes();
  }

  Future<void> fetchClothes({String? category}) async {
    setState(() => loading = true);
    try {
      // Use the filter API so category filtering works
      clothes = await ApiService.filterClothes(category: category);
    } catch (e) {
      clothes = [];
      print("Error fetching clothes: $e");
    }
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Categories")),
      body: Column(
        children: [
          // Category dropdown
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedCategory,
              hint: const Text("Select Category"),
              isExpanded: true,
              items: categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (val) {
                setState(() => selectedCategory = val);
                fetchClothes(category: val);
              },
            ),
          ),
          // Clothes list
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : clothes.isEmpty
                ? const Center(child: Text("No clothes found"))
                : ListView.builder(
                    itemCount: clothes.length,
                    itemBuilder: (context, index) {
                      final cloth = clothes[index];
                      return ListTile(
                        leading: cloth.imagePaths.isNotEmpty
                            ? Image.network(
                                "http://10.0.2.2:5269${cloth.imagePaths.first}",
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.checkroom),
                        title: Text(cloth.name),
                        subtitle: Text(cloth.category),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
