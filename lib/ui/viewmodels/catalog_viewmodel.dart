import 'package:flutter/material.dart';
import '../../data/models/furniture_model.dart';
import '../../data/services/database_service.dart';

class CatalogViewModel extends ChangeNotifier {
  final DatabaseService _service = DatabaseService();
  List<FurnitureModel> items = [];
  bool isLoading = false;

  Future<void> loadCatalog() async {
    isLoading = true;
    notifyListeners();
    
    items = await _service.fetchFurniture();
    
    isLoading = false;
    notifyListeners();
  }
}