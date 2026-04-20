class FurnitureModel {
  final String id;
  final String name;
  final String modelUrl;

  FurnitureModel({required this.id, required this.name, required this.modelUrl});

  factory FurnitureModel.fromMap(Map<String, dynamic> data, String id) {
    return FurnitureModel(
      id: id,
      name: data['name'] ?? 'Unknown',
      modelUrl: data['modelUrl'] ?? '',
    );
  }
}