import 'dart:developer';

import 'cloth.dart';

class Outfit {
  final int id;
  final String name;
  final List<int> clothIds;
  final List<Cloth> cloths;

  Outfit({
    required this.id,
    required this.name,
    required this.clothIds,
    required this.cloths,
  });

  factory Outfit.fromJson(Map<String, dynamic> json) {
    List<Cloth> cloths = [];

    for (var item in json['cloths']) {
      cloths.add(Cloth.fromJson(item));
    }

    return Outfit(
      id: json['id'],
      name: json['name'],
      clothIds: List<int>.from(json['clothIds']),
      cloths: cloths,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'clothIds': clothIds,
    'cloths': cloths,
  };
}
