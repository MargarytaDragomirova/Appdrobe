import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/create_outfit_screen.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:flutter_application_1/services/auth_service.dart';
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
      appBar: AppBar(
        title: const Text("Outfits"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService.logout();

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),

      // ============================
      // FAB BUTTON TO ADD NEW CLOTH
      // ============================
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final loggedIn = await AuthService.isLoggedIn();

          if (!loggedIn) {
            final ok = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );

            if (ok != true) return;
          }

          bool? created = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateOutfitScreen()),
          );

          if (created == true) fetchOutfits();
        },

        backgroundColor: Colors.black87,
        child: const Icon(Icons.add, size: 28),
      ),
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
                                  ? ApiService.baseUrl + c.imagePaths.first
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
