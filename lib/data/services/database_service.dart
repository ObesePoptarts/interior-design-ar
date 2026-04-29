import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/furniture_model.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> uploadModel(String name, Uint8List fileBytes, String fileName) async {
    final ref = FirebaseStorage.instance.ref().child('models/${DateTime.now().millisecondsSinceEpoch}_$fileName');
    await ref.putData(fileBytes);
    final url = await ref.getDownloadURL();
    
    await _db.collection('furniture').add({
      'name': name,
      'modelUrl': url,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<FurnitureModel>> streamFurniture() {
    return _db.collection('furniture').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => FurnitureModel.fromMap(doc.data(), doc.id)).toList();
    });
  }
}