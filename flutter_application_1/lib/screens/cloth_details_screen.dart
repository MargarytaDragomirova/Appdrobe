import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/cloth.dart';
import '../services/api_service.dart';

class ClothDetailsScreen extends StatelessWidget {
  final Cloth cloth;

  const ClothDetailsScreen({super.key, required this.cloth});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(cloth.name)),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Image
            Center(
              child: cloth.imagePaths.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: "${ApiService.baseUrl}${cloth.imagePaths[0]}",
                      height: 250,
                      fit: BoxFit.cover,
                    )
                  : const Icon(Icons.image_not_supported, size: 100),
            ),

            const SizedBox(height: 20),

            Text(
              "Category: ${cloth.category}",
              style: const TextStyle(fontSize: 18),
            ),
            Text("Color: ${cloth.color}", style: const TextStyle(fontSize: 18)),
            Text(
              "Season: ${cloth.season}",
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              "Location: ${cloth.location}",
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
