import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import '../models/cloth.dart';
import '../services/api_service.dart';
import 'cloth_details_screen.dart';
import 'create_cloth_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Cloth>> _clothes;

  @override
  void initState() {
    super.initState();
    _fetchClothes();
  }

  void _fetchClothes() {
    _clothes = ApiService.getClothes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Wardrobe"),
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
            MaterialPageRoute(builder: (_) => const CreateClothScreen()),
          );

          if (created == true) _fetchClothes();
        },

        backgroundColor: Colors.black87,
        child: const Icon(Icons.add, size: 28),
      ),

      body: FutureBuilder<List<Cloth>>(
        future: _clothes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No clothes found'));
          }

          final clothes = snapshot.data!;
          return ListView.builder(
            itemCount: clothes.length,
            itemBuilder: (context, index) {
              final cloth = clothes[index];

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: cloth.imagePaths.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl:
                              "${ApiService.baseUrl}${cloth.imagePaths[0]}",
                          width: 60,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.image_not_supported),

                  // ============================
                  // TAPPING OPENS DETAILS PAGE
                  // ============================
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ClothDetailsScreen(cloth: cloth),
                      ),
                    );
                  },

                  title: Text(cloth.name),
                  subtitle: Text("${cloth.category} • ${cloth.color}"),

                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await ApiService.deleteCloth(cloth.id);
                      setState(() => _fetchClothes());
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
