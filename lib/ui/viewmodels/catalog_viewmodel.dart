import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/models/furniture_model.dart';
import '../../data/services/database_service.dart';

class CatalogViewModel extends ChangeNotifier {
  final DatabaseService _service = DatabaseService();
  List<FurnitureModel> items = [];
  bool isLoading = false;
  StreamSubscription<List<FurnitureModel>>? _subscription;

  void loadCatalog() {
    isLoading = true;
    notifyListeners();

    _subscription = _service.streamFurniture().listen((updatedList) {
      items = updatedList;
      isLoading = false;
      notifyListeners();
    }, onError: (error) {
      debugPrint("Error in stream: $error");
      isLoading = false;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}