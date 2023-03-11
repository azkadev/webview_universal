// // Copyright 2013 The Flutter Authors. All rights reserved.
// // Use of this source code is governed by a BSD-style license that can be
// // found in the LICENSE file.

// // ignore_for_file: public_member_api_docs

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// // #docregion platform_imports
// // Import for Android features.
// import 'package:webview_flutter_android/webview_flutter_android.dart';
// // Import for iOS features.
// import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
// // #enddocregion platform_imports

// void main() => runApp(const MaterialApp(home: WebViewExample()));

// class WebViewExample extends StatefulWidget {
//   const WebViewExample({super.key});

//   @override
//   State<WebViewExample> createState() => _WebViewExampleState();
// }

// class _WebViewExampleState extends State<WebViewExample> {
//   late final WebViewController webViewController;

//   @override
//   void initState() {
//     super.initState();
//     late final PlatformWebViewControllerCreationParams params;
//     if (WebViewPlatform.instance is WebKitWebViewPlatform) {
//       params = WebKitWebViewControllerCreationParams(
//         allowsInlineMediaPlayback: true,
//         mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
//       );
//     } else {
//       params = const PlatformWebViewControllerCreationParams();
//     }
//     webViewController = WebViewController.fromPlatformCreationParams(params);

//     if (!kIsWeb) {
//       webViewController.setJavaScriptMode(JavaScriptMode.unrestricted);
//       // webViewController.setBackgroundColor(const Color(0x00000000));
//       webViewController.setNavigationDelegate(
//         NavigationDelegate(
//           onProgress: (int progress) {
//             debugPrint('WebView is loading (progress : $progress%)');
//           },
//           onPageStarted: (String url) {
//             debugPrint('Page started loading: $url');
//           },
//           onPageFinished: (String url) {
//             debugPrint('Page finished loading: $url');
//           },
//           onWebResourceError: (WebResourceError error) {
//             debugPrint('''
// Page resource error:
//   code: ${error.errorCode}
//   description: ${error.description}
//   errorType: ${error.errorType}
//   isForMainFrame: ${error.isForMainFrame}
//           ''');
//           },
//           onNavigationRequest: (NavigationRequest request) {
//             if (request.url.startsWith('https://www.youtube.com/')) {
//               debugPrint('blocking navigation to ${request.url}');
//               return NavigationDecision.prevent;
//             }
//             debugPrint('allowing navigation to ${request.url}');
//             return NavigationDecision.navigate;
//           },
//         ),
//       );
//       webViewController.addJavaScriptChannel(
//         'Toaster',
//         onMessageReceived: (JavaScriptMessage message) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(message.message)),
//           );
//         },
//       );
//     }

//     webViewController.loadRequest(Uri.parse("https://checkout-staging.xendit.co/web/640c81da4dce5edecc8af80d"));
//     // #docregion platform_features
//     if (webViewController.platform is AndroidWebViewController) {
//       AndroidWebViewController.enableDebugging(false);
//       (webViewController.platform as AndroidWebViewController).setMediaPlaybackRequiresUserGesture(false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // backgroundColor: Colors.green,
//       appBar: AppBar(
//         title: const Text('Flutter WebView example'),
//         // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
//         actions: <Widget>[
//           NavigationControls(webViewController: webViewController),
//           // SampleMenu(webViewController: _controller),
//         ],
//       ),
//       body: WebViewWidget(
//         controller: webViewController,
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           print("azka");
//           await webViewController.loadRequest(Uri.parse("https://checkout-staging.xendit.co/web/640c8077bda105004e1dc6f2"));
//         },
//         child: Icon(
//           Icons.add_circle_outline_sharp,
//         ),
//       ),
//     );
//   }
// }

// class NavigationControls extends StatelessWidget {
//   const NavigationControls({
//     super.key,
//     required this.webViewController,
//   });

//   final WebViewController webViewController;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: <Widget>[
//         IconButton(
//           icon: const Icon(Icons.arrow_back_ios),
//           onPressed: () async {
//             await webViewController.loadRequest(Uri.parse("https://checkout-staging.xendit.co/web/640c8077bda105004e1dc6f2"));
//           },
//         ),
//         IconButton(
//           icon: const Icon(Icons.arrow_back_ios),
//           onPressed: () async {
//             if (await webViewController.canGoBack()) {
//               await webViewController.goBack();
//             } else {
//               if (context.mounted) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('No back history item')),
//                 );
//               }
//             }
//           },
//         ),
//         IconButton(
//           icon: const Icon(Icons.arrow_forward_ios),
//           onPressed: () async {
//             if (await webViewController.canGoForward()) {
//               await webViewController.goForward();
//             } else {
//               if (context.mounted) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('No forward history item')),
//                 );
//               }
//             }
//           },
//         ),
//         IconButton(
//           icon: const Icon(Icons.replay),
//           onPressed: () => webViewController.reload(),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart'; 
import "package:webview_universal/webview_universal.dart";

void main(List<String> args) {
  runApp(const MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  WebViewController webViewController = WebViewController();

  @override
  void initState() {
    super.initState();

    webViewController.init(
      context: context,
      uri: Uri.parse("https://flutter.dev"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      controller: webViewController,
    );
  }
}
