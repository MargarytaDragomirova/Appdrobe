import 'cloth.dart';

class Outfit {
  final int id;
  final String name;
  final List<Cloth> clothes;

  Outfit({required this.id, required this.name, required this.clothes});

  factory Outfit.fromJson(Map<String, dynamic> json) => Outfit(
    id: json['id'],
    name: json['name'],
    clothes: (json['clothes'] as List<dynamic>)
        .map((c) => Cloth.fromJson(c))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'clothes': clothes.map((c) => c.toJson()).toList(),
  };
}
