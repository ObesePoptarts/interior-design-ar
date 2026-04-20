import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/catalog_viewmodel.dart';
import 'ar_screen.dart';
import 'package:file_picker/file_picker.dart';
import '../../data/services/database_service.dart';

class CatalogTab extends StatelessWidget {
  const CatalogTab({super.key});

  void _showUploadDialog(BuildContext context) {
  final nameController = TextEditingController();
  PlatformFile? pickedFile;

  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setDialogState) => AlertDialog(
        title: const Text("Upload 3D Model"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Model Name")),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.pickFiles(type: FileType.any);
                if (result != null) {
                  setDialogState(() => pickedFile = result.files.first);
                }
              },
              child: Text(pickedFile == null ? "Select .glb File" : "File Selected!"),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: pickedFile == null ? null : () async {
              Navigator.pop(context);
              
              await DatabaseService().uploadModel(
                nameController.text, 
                pickedFile!.bytes!, 
                pickedFile!.name
              );
            },
            child: const Text("Upload"),
          ),
        ],
      ),
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    
    return ChangeNotifierProvider(
      create: (_) => CatalogViewModel()..loadCatalog(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Furniture Catalog"),
          elevation: 0,
        ),
        body: Consumer<CatalogViewModel>(
          builder: (context, viewModel, child) {
            
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            
            if (viewModel.items.isEmpty) {
              return const Center(
                child: Text("No models found. Try adding one!"),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: viewModel.items.length,
              itemBuilder: (context, index) {
                final item = viewModel.items[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.chair, size: 30, color: Colors.blue),
                    ),
                    title: Text(
                      item.name, 
                      style: const TextStyle(fontWeight: FontWeight.bold)
                    ),
                    subtitle: Text("ID: ${item.id}"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      
                      print("Tapped on ${item.name}");
                      Navigator.push(
                      context,
                      MaterialPageRoute(
                      builder: (context) => ArScreen(modelUrl: item.modelUrl),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showUploadDialog(context), 
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}