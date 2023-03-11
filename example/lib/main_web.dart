// import 'dart:io';

// import 'package:webview_universal/webview_desktop/webview_universal.dart';
// import 'package:flutter/material.dart';
// import 'package:path/path.dart' as p;
// import 'package:path_provider/path_provider.dart';

// void main(List<String> args) {
//   debugPrint('args: $args');
//   if (runWebViewTitleBarWidget(args)) {
//     return;
//   }
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   final TextEditingController _controller = TextEditingController(
//     text: 'https://example.com',
//   );

//   bool? _webviewAvailable;

//   @override
//   void initState() {
//     super.initState();
//     WebviewWindow.isWebviewAvailable().then((value) {
//       setState(() {
//         _webviewAvailable = value;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Plugin example app'),
//           actions: [
//             IconButton(
//               onPressed: () async {
//                 final webview = await WebviewWindow.create(
//                   configuration: CreateConfiguration(
//                     windowHeight: 1280,
//                     windowWidth: 720,
//                     title: "ExampleTestWindow",
//                     titleBarTopPadding: Platform.isMacOS ? 20 : 0,
//                     userDataFolderWindows: await _getWebViewPath(),
//                   ),
//                 );
//                 webview
//                   ..registerJavaScriptMessageHandler("test", (name, body) {
//                     debugPrint('on javaScipt message: $name $body');
//                   })
//                   ..setApplicationNameForUserAgent(" WebviewExample/1.0.0")
//                   ..setPromptHandler((prompt, defaultText) {
//                     if (prompt == "test") {
//                       return "Hello World!";
//                     } else if (prompt == "init") {
//                       return "initial prompt";
//                     }
//                     return "";
//                   })
//                   ..addScriptToExecuteOnDocumentCreated("""
//   const mixinContext = {
//     platform: 'Desktop',
//     conversation_id: 'conversationId',
//     immersive: false,
//     app_version: '1.0.0',
//     appearance: 'dark',
//   }
//   window.MixinContext = {
//     getContext: function() {
//       return JSON.stringify(mixinContext)
//     }
//   }
// """)
//                   ..launch("http://localhost:3000/test.html");
//               },
//               icon: const Icon(Icons.bug_report),
//             )
//           ],
//         ),
//         body: Center(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 TextField(controller: _controller),
//                 const SizedBox(height: 16),
//                 TextButton(
//                   onPressed: _webviewAvailable != true ? null : _onTap,
//                   child: const Text('Open'),
//                 ),
//                 const SizedBox(height: 20),
//                 TextButton(
//                   onPressed: () async {
//                     await WebviewWindow.clearAll(
//                       userDataFolderWindows: await _getWebViewPath(),
//                     );
//                     debugPrint('clear complete');
//                   },
//                   child: const Text('Clear all'),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _onTap() async {
//     final webview = await WebviewWindow.create(
//       configuration: CreateConfiguration(
//         userDataFolderWindows: await _getWebViewPath(),
//         titleBarTopPadding: Platform.isMacOS ? 20 : 0,
//       ),
//     );
//     webview
//       ..setBrightness(Brightness.dark)
//       ..setApplicationNameForUserAgent(" WebviewExample/1.0.0")
//       ..launch(_controller.text)
//       ..addOnUrlRequestCallback((url) {
//         debugPrint('url: $url');
//         final uri = Uri.parse(url);
//         if (uri.path == '/login_success') {
//           debugPrint('login success. token: ${uri.queryParameters['token']}');
//           webview.close();
//         }
//       })
//       ..onClose.whenComplete(() {
//         debugPrint("on close");
//       });
//     await Future.delayed(const Duration(seconds: 2));
//     for (final javaScript in _javaScriptToEval) {
//       try {
//         final ret = await webview.evaluateJavaScript(javaScript);
//         debugPrint('evaluateJavaScript: $ret');
//       } catch (e) {
//         debugPrint('evaluateJavaScript error: $e \n $javaScript');
//       }
//     }
//   }
// }

// const _javaScriptToEval = [
//   """
//   function test() {
//     return;
//   }
//   test();
//   """,
//   'eval({"name": "test", "user_agent": navigator.userAgent})',
//   '1 + 1',
//   'undefined',
//   '1.0 + 1.0',
//   '"test"',
// ];

// Future<String> _getWebViewPath() async {
//   final document = await getApplicationDocumentsDirectory();
//   return p.join(
//     document.path,
//     'webview_universal',
//   );
// }

// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:webview_flutter_web/webview_flutter_web.dart';

void main() {
  WebViewPlatform.instance = WebWebViewPlatform();
  runApp(const MaterialApp(home: _WebViewExample()));
}

class _WebViewExample extends StatefulWidget {
  const _WebViewExample({Key? key}) : super(key: key);

  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<_WebViewExample> {
  final PlatformWebViewController _controller = PlatformWebViewController(
    const PlatformWebViewControllerCreationParams(),
  )..loadRequest(
      LoadRequestParams(
        uri: Uri.parse('https://flutter.dev'),
      ),
    );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter WebView example'),
        actions: <Widget>[
          _SampleMenu(_controller),
        ],
      ),
      body: PlatformWebViewWidget(
        PlatformWebViewWidgetCreationParams(controller: _controller),
      ).build(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print("tap");
          await _controller.loadRequest(
            LoadRequestParams(
              uri: Uri.parse('https://google.com'),
            ),
          );
          print("tap slebew");
        },
        child: Icon(Icons.abc),
      ),
    );
  }
}

enum _MenuOptions {
  doPostRequest,
}

class _SampleMenu extends StatelessWidget {
  const _SampleMenu(this.controller);

  final PlatformWebViewController controller;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_MenuOptions>(
      onSelected: (_MenuOptions value) async{
          await controller.loadRequest(
            LoadRequestParams(
              uri: Uri.parse('https://google.com'),
            ),
          );
        
      },
      itemBuilder: (BuildContext context) => <PopupMenuItem<_MenuOptions>>[
        const PopupMenuItem<_MenuOptions>(
          value: _MenuOptions.doPostRequest,
          child: Text('Post Request'),
        ), 
      ],
    );
  }

  Future<void> _onDoPostRequest(PlatformWebViewController controller) async {
    final LoadRequestParams params = LoadRequestParams(
      uri: Uri.parse('https://httpbin.org/post'),
      method: LoadRequestMethod.post,
      headers: const <String, String>{'foo': 'bar', 'Content-Type': 'text/plain'},
      body: Uint8List.fromList('Test Body'.codeUnits),
    );
    await controller.loadRequest(params);
  }
}
