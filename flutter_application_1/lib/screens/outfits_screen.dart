import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/outfit.dart';
import '../models/cloth.dart';

class OutfitsScreen extends StatefulWidget {
  const OutfitsScreen({super.key});

  @override
  State<OutfitsScreen> createState() => _OutfitsScreenState();
}

class _OutfitsScreenState extends State<OutfitsScreen> {
  List<Outfit> outfits = [];
  Map<int, List<Cloth>> outfitClothes = {}; // outfitId -> clothes
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchOutfits();
  }

  Future<void> fetchOutfits() async {
    setState(() => loading = true);
    try {
      outfits = await ApiService.getOutfits();

      // Fetch clothes for each outfit
      // for (var outfit in outfits) {
      //   final fullOutfit = await ApiService.getOutfit(outfit.id);
      //   outfitClothes[outfit.id] = fullOutfit.clothes;
      // }
    } catch (e) {
      print("Error fetching outfits: $e");
      outfits = [];
      outfitClothes = {};
    }
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Outfits")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : outfits.isEmpty
          ? const Center(child: Text("No outfits yet"))
          : ListView.builder(
              itemCount: outfits.length,
              itemBuilder: (context, index) {
                final outfit = outfits[index];

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(outfit.name),
                    subtitle: outfit.cloths.isEmpty
                        ? const Text("No clothes")
                        : Wrap(
                            spacing: 5,
                            children: outfit.cloths.map((c) {
                              final imageUrl = c.imagePaths.isNotEmpty
                                  ? "http://10.0.2.2:5269${c.imagePaths.first.toString()}"
                                  : "";
                              return imageUrl.isNotEmpty
                                  ? Image.network(
                                      imageUrl,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(Icons.checkroom);
                            }).toList(),
                          ),
                  ),
                );
              },
            ),
    );
  }
}
