import 'package:ar_flutter_plugin_plus/models/ar_anchor.dart';
import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin_plus/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_plus/models/ar_node.dart';
import 'package:ar_flutter_plugin_plus/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin_plus/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_plus/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_plus/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin_plus/models/ar_hittest_result.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import '../widgets/ar_view_wrapper.dart';
import 'catalog_tab.dart';

class ArScreen extends StatefulWidget {
  final String? modelUrl;

  const ArScreen({super.key, this.modelUrl});

  @override
  State<ArScreen> createState() => _ArScreenState();
}

class _ArScreenState extends State<ArScreen> {
  ARObjectManager? arObjectManager;
  ARSessionManager? arSessionManager;
  ARAnchorManager? arAnchorManager;

  String? _selectedModelUrl;

  @override
  void initState() {
    super.initState();
    _selectedModelUrl = widget.modelUrl;
  }

  void _showCatalogPicker(){
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6, 
          child: CatalogTab(
            onModelSelected: (String url) {
              setState(() {
                _selectedModelUrl = url;
              });
              Navigator.pop(context); 
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Furniture selected! Tap a plane to place.")),
              );
            },
          ),
        );
      },
    );
  }
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AR Furniture")),
      body: ARViewWrapper(
        onARViewCreated: onARViewCreated,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCatalogPicker,
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add_business_outlined, color: Colors.white),
      ),
    );
  }

  void onARViewCreated(
    ARSessionManager sessionManager,
    ARObjectManager objectManager,
    ARAnchorManager anchorManager,
    ARLocationManager locationManager,
  ) {
    arSessionManager = sessionManager;
    arObjectManager = objectManager;
    arAnchorManager = anchorManager;

    arSessionManager!.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      customPlaneTexturePath: "assets/triangle.png",
      handleTaps: true,
    );

    arSessionManager!.onPlaneOrPointTap = onPlaneOrPointTapped;
  }

  void onPlaneOrPointTapped(List<ARHitTestResult> hitTestResults) async {
    if (hitTestResults.isNotEmpty) {
      var singleHitTestResult = hitTestResults.first;
      var newAnchor = ARPlaneAnchor(transformation: singleHitTestResult.worldTransform);
      bool? didAddAnchor = await arAnchorManager!.addAnchor(newAnchor);

      if (didAddAnchor ?? false) {
        var newNode = ARNode(
          type: NodeType.webGLB,
          // Use the locally selected model, fallback to the duck
          uri: _selectedModelUrl ?? "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Duck/glTF-Binary/Duck.glb",
          scale: vector.Vector3(0.2, 0.2, 0.2),
        );

        arObjectManager!.addNode(newNode, planeAnchor: newAnchor);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    arSessionManager?.dispose();
  }
}