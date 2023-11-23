
class Spot {
  final int id;
  final String name;
  final String description;
  final bool isSummer;

  Spot(
      {required this.id,
      required this.name,
      required this.description,
      required this.isSummer});

  factory Spot.fromJson(Map<String, dynamic> json) {
    return Spot(
        id: json['id'],
        name: json['name'],
        description: json['description'] ?? "unknown",
        isSummer: json['issummer']);
  }
}
