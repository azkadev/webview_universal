import 'package:flutter/material.dart';

class Webview {
  setBrightness(Brightness brightness) {}
  launch(String url) {}
}

class WebviewWindow {
  static Future<bool> isWebviewAvailable() async {
    return false;
  }

  static Future<Webview> create({required configuration}) async {
    return Webview();
  }
}

class CreateConfiguration {
  final double titleBarTopPadding;
  CreateConfiguration({
    required this.titleBarTopPadding,
  });
}
