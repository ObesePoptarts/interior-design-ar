import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin_plus/ar_flutter_plugin_plus.dart';
import 'package:ar_flutter_plugin_plus/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin_plus/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_plus/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_plus/managers/ar_anchor_manager.dart';

abstract class ARService {
  Widget buildARView(Function(ARSessionManager, ARObjectManager, ARAnchorManager, ARLocationManager) onCreated);
}

class RealARService implements ARService {
  @override
  Widget buildARView(Function(ARSessionManager, ARObjectManager, ARAnchorManager, ARLocationManager) onCreated) {
    return ARView(onARViewCreated: onCreated);
  }
}

class MockARService implements ARService {
  @override
  Widget buildARView(Function(ARSessionManager, ARObjectManager, ARAnchorManager, ARLocationManager) onCreated) {
    return Container(
      color: Colors.grey[900],
      child: const Center(child: Text("AR requires a compatible physical mobile device")),
    );
  }
}