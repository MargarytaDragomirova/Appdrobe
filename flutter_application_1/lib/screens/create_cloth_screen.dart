import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';

class CreateClothScreen extends StatefulWidget {
  const CreateClothScreen({super.key});

  @override
  State<CreateClothScreen> createState() => _CreateClothScreenState();
}

class _CreateClothScreenState extends State<CreateClothScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  String name = "";
  String? category;
  String? color;
  String? season;
  String? location;

  List<XFile> selectedImages = [];
  bool _loading = false;

  // CATEGORY OPTIONS
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

  // COLOR OPTIONS
  final List<String> colors = [
    "Black",
    "White",
    "Blue",
    "Red",
    "Green",
    "Yellow",
    "Beige",
    "Gray",
    "Pink",
    "Purple",
    "Brown",
  ];

  final List<String> seasons = [
    "Summer",
    "Winter",
    "Spring",
    "Autumn",
    "All Seasons",
  ];
  final List<String> locations = ["Wardrobe", "Drawer", "Laundry", "Storage"];

  Future<void> pickFromGallery() async {
    final images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() => selectedImages.addAll(images));
    }
  }

  Future<void> pickFromCamera() async {
    final image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() => selectedImages.add(image));
    }
  }

  void showImageSourceSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  pickFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () {
                  Navigator.pop(context);
                  pickFromCamera();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedImages.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Select at least 1 image")));
      return;
    }

    setState(() => _loading = true);

    final success = await ApiService.createCloth(
      name: name,
      category: category ?? "",
      color: color ?? "",
      season: season ?? "",
      location: location ?? "",
      images: selectedImages.map((x) => File(x.path)).toList(),
    );

    setState(() => _loading = false);

    if (success) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error creating cloth")));
    }
  }

  Widget buildDropdown({
    required String label,
    required List<String> items,
    required String? value,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label),
      value: value,
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
      validator: (v) => v == null ? "Required" : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Cloth")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // IMAGE PICKER
                    GestureDetector(
                      onTap: showImageSourceSelector,
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: selectedImages.isEmpty
                            ? const Center(child: Text("Tap to pick images"))
                            : ListView(
                                scrollDirection: Axis.horizontal,
                                children: selectedImages.map((img) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Image.file(
                                      File(img.path),
                                      width: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                }).toList(),
                              ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // NAME
                    TextFormField(
                      decoration: const InputDecoration(labelText: "Name"),
                      validator: (v) => v!.isEmpty ? "Required" : null,
                      onChanged: (v) => name = v,
                    ),

                    const SizedBox(height: 15),

                    // CATEGORY
                    buildDropdown(
                      label: "Category",
                      items: categories,
                      value: category,
                      onChanged: (v) => setState(() => category = v),
                    ),

                    const SizedBox(height: 15),

                    // COLOR
                    buildDropdown(
                      label: "Color",
                      items: colors,
                      value: color,
                      onChanged: (v) => setState(() => color = v),
                    ),

                    const SizedBox(height: 15),

                    // SEASON
                    buildDropdown(
                      label: "Season",
                      items: seasons,
                      value: season,
                      onChanged: (v) => setState(() => season = v),
                    ),

                    const SizedBox(height: 15),

                    // LOCATION
                    buildDropdown(
                      label: "Location",
                      items: locations,
                      value: location,
                      onChanged: (v) => setState(() => location = v),
                    ),

                    const SizedBox(height: 25),

                    // SUBMIT BUTTON
                    ElevatedButton(
                      onPressed: submit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 35,
                          vertical: 14,
                        ),
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Create Cloth"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
