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
      setState: setState,
      uri: Uri.parse("https://flutter.dev"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: FloatingActionButton(
          onPressed: () {
            webViewController.goBackSync();
          },
          child: Icon(Icons.abc),
        ),
      ),
      body: WebView(
        controller: webViewController,
      ),
    );
  }
}
