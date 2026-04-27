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

class ArScreen extends StatefulWidget {
  final String? modelUrl;

  const ArScreen({super.key, this.modelUrl});

  @override
  State<ArScreen> createState() => _ArScreenState();
}

class _ArScreenState extends State<ArScreen> {
  ARObjectManager? arObjectManager;
  ARSessionManager? arSessionManager;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AR Furniture")),
      // Use the wrapper here instead of raw ARView to prevent crashes
      body: ARViewWrapper(
        onARViewCreated: onARViewCreated,
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

    arSessionManager!.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
    );

    arSessionManager!.onPlaneOrPointTap = onPlaneOrPointTapped;
  }

  void onPlaneOrPointTapped(List<ARHitTestResult> hitTestResults) {
    if (hitTestResults.isNotEmpty) {
      ARHitTestResult hit = hitTestResults.first;

      var newNode = ARNode(
        type: NodeType.webGLB,
        uri: widget.modelUrl ??
            "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Duck/glTF-Binary/Duck.glb",
        scale: vector.Vector3(0.2, 0.2, 0.2),
        position: vector.Vector3(
          hit.worldTransform.getColumn(3).x,
          hit.worldTransform.getColumn(3).y,
          hit.worldTransform.getColumn(3).z,
        ),
      );
      arObjectManager!.addNode(newNode);
    }
  }

  @override
  void dispose() {
    super.dispose();
    // Always dispose of the session to prevent memory leaks
    arSessionManager?.dispose();
  }
}