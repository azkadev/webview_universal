import "package:universal_io/io.dart";
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart' as webview_flutter;
import "package:webview_universal/webview_controller/webview_controller.dart" as webview_controller;

class WebView extends StatelessWidget {
  final webview_controller.WebViewController controller;

  const WebView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    if (!controller.is_init) {
      return const SizedBox.shrink();
    }
    if (Platform.isAndroid || Platform.isIOS || kIsWeb) {
      return Visibility(
        visible: controller.is_init,
        replacement: const SizedBox.shrink(),
        child: webview_flutter.WebViewWidget(
          controller: controller.webview_mobile_controller,
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
