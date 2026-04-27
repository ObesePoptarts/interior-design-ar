import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin_plus/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin_plus/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_plus/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_plus/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin_plus/managers/ar_location_manager.dart';

class ARViewWrapper extends StatelessWidget {
  final Function(ARSessionManager, ARObjectManager, ARAnchorManager, ARLocationManager) onARViewCreated;

  const ARViewWrapper({super.key, required this.onARViewCreated});

  @override
  Widget build(BuildContext context) {
    // If running on web, show a friendly message instead of the ARView
    if (kIsWeb) {
      return const Center(
        child: Text("AR features are only available on physical mobile devices."),
      );
    }
    
    // Only load the real ARView on mobile
    return ARView(
      onARViewCreated: onARViewCreated,
    );
  }
}