class Cloth {
  final int id;
  final String name;
  final String category;
  final String color;
  final String season;
  final String? location;
  final List<String> imagePaths;

  Cloth({
    required this.id,
    required this.name,
    required this.category,
    required this.color,
    required this.season,
    this.location,
    required this.imagePaths,
  });

  factory Cloth.fromJson(Map<String, dynamic> json) {
    return Cloth(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      color: json['color'],
      season: json['season'],
      location: json['location'],
      imagePaths: List<String>.from(json['imagePaths'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "category": category,
    "color": color,
    "season": season,
    "location": location,
    "imagePaths": imagePaths,
  };
}
