import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/furniture_model.dart';
import 'dart:typed_data'; // Add this for file data
import 'package:firebase_storage/firebase_storage.dart'; // Add this

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> uploadModel(String name, Uint8List fileBytes, String fileName) async {
  // 1. Create a reference to storage
  final ref = FirebaseStorage.instance.ref().child('models/${DateTime.now().millisecondsSinceEpoch}_$fileName');
  
  // 2. Upload the file
  await ref.putData(fileBytes);
  
  // 3. Get the download URL
  final url = await ref.getDownloadURL();
  
  // 4. Save to Firestore
  await FirebaseFirestore.instance.collection('furniture').add({
    'name': name,
    'modelUrl': url,
  });
}
  Future<List<FurnitureModel>> fetchFurniture() async {
    print("Fetching data from Firestore..."); // <--- ADD THIS
    try {
      final snapshot = await _db.collection('furniture').get();
      print("Fetch complete! Found ${snapshot.docs.length} documents."); // <--- ADD THIS
      
      return snapshot.docs.map((doc) => FurnitureModel.fromMap(doc.data(), doc.id)).toList();
    } catch (e) {
      print("ERROR IN FIRESTORE: $e"); // <--- ADD THIS
      return [];
    }
  }
}