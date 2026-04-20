import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/furniture_model.dart';
import 'dart:typed_data'; 
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> uploadModel(String name, Uint8List fileBytes, String fileName) async {

  final ref = FirebaseStorage.instance.ref().child('models/${DateTime.now().millisecondsSinceEpoch}_$fileName');
  
  await ref.putData(fileBytes);
  
  final url = await ref.getDownloadURL();
  
  await FirebaseFirestore.instance.collection('furniture').add({
    'name': name,
    'modelUrl': url,
  });
}
  Future<List<FurnitureModel>> fetchFurniture() async {
    print("Fetching data from Firestore...");
    try {
      final snapshot = await _db.collection('furniture').get();
      print("Fetch complete! Found ${snapshot.docs.length} documents.");
      
      return snapshot.docs.map((doc) => FurnitureModel.fromMap(doc.data(), doc.id)).toList();
    } catch (e) {
      print("ERROR IN FIRESTORE: $e"); 
      return [];
    }
  }
}