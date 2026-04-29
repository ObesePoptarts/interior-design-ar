import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../viewmodels/catalog_viewmodel.dart';
import '../../data/services/database_service.dart';
import 'ar_screen.dart';

class CatalogTab extends StatelessWidget {
  const CatalogTab({super.key});

  void _showUploadDialog(BuildContext context) {
    final nameController = TextEditingController();
    PlatformFile? pickedFile;
    bool isUploading = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text("Upload 3D Model"),
          content: isUploading
              ? const SizedBox(height: 100, child: Center(child: CircularProgressIndicator()))
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(controller: nameController, decoration: const InputDecoration(labelText: "Model Name")),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        FilePickerResult? result = await FilePicker.pickFiles(type: FileType.custom,allowedExtensions: ['glb', 'gltf'], withData: true);
                        if (result != null) {
                          setDialogState(() => pickedFile = result.files.first);
                        }
                      },
                      child: Text(pickedFile == null ? "Select .glb File" : "File Selected: ${pickedFile!.name}"),
                    ),
                  ],
                ),
          actions: [
            if (!isUploading) ...[
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
              ElevatedButton(
                onPressed: pickedFile == null || isUploading ? null : () async {

                  if (pickedFile!.bytes == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Error: File Data is empty. Try a diffent File."))
                    );
                    return;
                  }

                  setDialogState(() => isUploading = true);
                  try {
                    await DatabaseService().uploadModel(
                      nameController.text,
                      pickedFile!.bytes!,
                      pickedFile!.name,
                    );
                    if (context.mounted) Navigator.pop(context);
                  } catch (e) {
                    setDialogState(() => isUploading = false);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
                  }
                },
                child: const Text("Upload"),
              ),
            ]
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
        appBar: AppBar(title: const Text("Furniture Catalog")),
        body: Consumer<CatalogViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) return const Center(child: CircularProgressIndicator());
            
            return ListView.builder(
              itemCount: viewModel.items.length,
              itemBuilder: (context, index) {
                final item = viewModel.items[index];
                return ListTile(
                  leading: const Icon(Icons.chair),
                  title: Text(item.name),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ArScreen(modelUrl: item.modelUrl)),
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