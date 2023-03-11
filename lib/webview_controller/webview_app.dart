// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs, non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart' as webview_flutter; 
import 'package:webview_flutter_android/webview_flutter_android.dart' as webview_flutter_android; 
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart' as webview_flutter_wkwebview; 
class WebViewController {
  late final webview_flutter.WebViewController webview_movile_controller;

  bool is_init = false;

  WebViewController();

  Future<void> init({
    required BuildContext context,
    required Uri uri,
  }) async {
    late final webview_flutter.PlatformWebViewControllerCreationParams params;
    if (webview_flutter.WebViewPlatform.instance is webview_flutter_wkwebview.WebKitWebViewPlatform) {
      params = webview_flutter_wkwebview.WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <webview_flutter_wkwebview.PlaybackMediaTypes>{},
      );
    } else {
      params = const webview_flutter.PlatformWebViewControllerCreationParams();
    }
    webview_movile_controller = webview_flutter.WebViewController.fromPlatformCreationParams(params);

    if (!kIsWeb) {
      webview_movile_controller.setJavaScriptMode(webview_flutter.JavaScriptMode.unrestricted);
      // webViewController.setBackgroundColor(const Color(0x00000000));
      webview_movile_controller.setNavigationDelegate(
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
      webview_movile_controller.addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (webview_flutter.JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      );
    }
    webview_movile_controller.loadRequest(uri);
    // #docregion platform_features
    if (webview_movile_controller.platform is webview_flutter_android.AndroidWebViewController) {
      webview_flutter_android.AndroidWebViewController.enableDebugging(false);
      (webview_movile_controller.platform as webview_flutter_android.AndroidWebViewController).setMediaPlaybackRequiresUserGesture(false);
    }
  }
  
}

void main() => runApp(const MaterialApp(home: WebViewExample()));

class WebViewExample extends StatefulWidget {
  const WebViewExample({super.key});

  @override
  State<WebViewExample> createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  late final webview_flutter.WebViewController webViewController;

  @override
  void initState() {
    super.initState();
    late final webview_flutter.PlatformWebViewControllerCreationParams params;
    if (webview_flutter.WebViewPlatform.instance is webview_flutter_wkwebview.WebKitWebViewPlatform) {
      params = webview_flutter_wkwebview.WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <webview_flutter_wkwebview.PlaybackMediaTypes>{},
      );
    } else {
      params = const webview_flutter.PlatformWebViewControllerCreationParams();
    }
    webViewController = webview_flutter.WebViewController.fromPlatformCreationParams(params);

    if (!kIsWeb) {
      webViewController.setJavaScriptMode(webview_flutter.JavaScriptMode.unrestricted);
      // webViewController.setBackgroundColor(const Color(0x00000000));
      webViewController.setNavigationDelegate(
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
      webViewController.addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (webview_flutter.JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      );
    }

    webViewController.loadRequest(Uri.parse("https://checkout-staging.xendit.co/web/640c81da4dce5edecc8af80d"));
    // #docregion platform_features
    if (webViewController.platform is webview_flutter_android.AndroidWebViewController) {
      webview_flutter_android.AndroidWebViewController.enableDebugging(false);
      (webViewController.platform as webview_flutter_android.AndroidWebViewController).setMediaPlaybackRequiresUserGesture(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.green,
      appBar: AppBar(
        title: const Text('Flutter WebView example'),
        // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
        actions: <Widget>[
          NavigationControls(webViewController: webViewController),
          // SampleMenu(webViewController: _controller),
        ],
      ),
      body: webview_flutter.WebViewWidget(
        controller: webViewController,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print("azka");
          await webViewController.loadRequest(Uri.parse("https://checkout-staging.xendit.co/web/640c8077bda105004e1dc6f2"));
        },
        child: Icon(
          Icons.add_circle_outline_sharp,
        ),
      ),
    );
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls({
    super.key,
    required this.webViewController,
  });

  final webview_flutter.WebViewController webViewController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () async {
            await webViewController.loadRequest(Uri.parse("https://checkout-staging.xendit.co/web/640c8077bda105004e1dc6f2"));
          },
        ),
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () async {
            if (await webViewController.canGoBack()) {
              await webViewController.goBack();
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No back history item')),
                );
              }
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () async {
            if (await webViewController.canGoForward()) {
              await webViewController.goForward();
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No forward history item')),
                );
              }
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.replay),
          onPressed: () => webViewController.reload(),
        ),
      ],
    );
  }
}
