// ignore_for_file: non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:universal_io/io.dart';
import 'package:webview_flutter/webview_flutter.dart' as webview_flutter;
import 'package:webview_flutter_android/webview_flutter_android.dart' as webview_flutter_android;
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart' as webview_flutter_wkwebview;
import "package:webview_universal/webview_desktop/webview_desktop.dart" as webview_desktop;

class WebViewController {
  late final webview_flutter.WebViewController webview_mobile_controller;
  late final webview_desktop.Webview webview_desktop_controller;
  bool is_init = false;
  bool is_desktop = false;
  bool is_mobile = (kIsWeb || Platform.isAndroid || Platform.isIOS);
  WebViewController();
  Future<void> init({
    required BuildContext context,
    required Uri uri,
  }) async {
    if (is_mobile) {
      late final webview_flutter.PlatformWebViewControllerCreationParams params;
      if (webview_flutter.WebViewPlatform.instance is webview_flutter_wkwebview.WebKitWebViewPlatform) {
        params = webview_flutter_wkwebview.WebKitWebViewControllerCreationParams(
          allowsInlineMediaPlayback: true,
          mediaTypesRequiringUserAction: const <webview_flutter_wkwebview.PlaybackMediaTypes>{},
        );
      } else {
        params = const webview_flutter.PlatformWebViewControllerCreationParams();
      }
      webview_mobile_controller = webview_flutter.WebViewController.fromPlatformCreationParams(params);
      is_init = true;
      if (!kIsWeb) {
        await webview_mobile_controller.setJavaScriptMode(webview_flutter.JavaScriptMode.unrestricted);
        await webview_mobile_controller.setNavigationDelegate(
          webview_flutter.NavigationDelegate(
            onProgress: (int progress) {
              debugPrint('WebView is loading (progress : $progress%)');
            },
            onPageStarted: (String url) {
              debugPrint('Page started loading: $url');
            },
            onPageFinished: (String url) {
              debugPrint('Page finished loading: $url');
            },
            onWebResourceError: (webview_flutter.WebResourceError error) {
              debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
            },
            onNavigationRequest: (webview_flutter.NavigationRequest request) {
              if (request.url.startsWith('https://www.youtube.com/')) {
                debugPrint('blocking navigation to ${request.url}');
                return webview_flutter.NavigationDecision.prevent;
              }
              debugPrint('allowing navigation to ${request.url}');
              return webview_flutter.NavigationDecision.navigate;
            },
          ),
        );
        await webview_mobile_controller.addJavaScriptChannel(
          'Toaster',
          onMessageReceived: (webview_flutter.JavaScriptMessage message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message.message)),
            );
          },
        );
      }
      await webview_mobile_controller.loadRequest(uri);
      // #docregion platform_features
      if (webview_mobile_controller.platform is webview_flutter_android.AndroidWebViewController) {
        await webview_flutter_android.AndroidWebViewController.enableDebugging(false);
        await (webview_mobile_controller.platform as webview_flutter_android.AndroidWebViewController).setMediaPlaybackRequiresUserGesture(false);
      }
    } else {
      bool isWebviewAvailable = await webview_desktop.WebviewWindow.isWebviewAvailable();
      if (isWebviewAvailable) {
        webview_desktop.Webview webview_desktop_controller = await webview_desktop.WebviewWindow.create(
          configuration: webview_desktop.CreateConfiguration(
            titleBarTopPadding: Platform.isMacOS ? 20 : 0,
          ),
        );
        webview_desktop_controller.setBrightness(Brightness.dark);
        webview_desktop_controller.launch(uri.toString());
      }
    }
  }
}
