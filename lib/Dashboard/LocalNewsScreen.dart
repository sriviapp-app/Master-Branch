import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LocalNewsScreen extends StatefulWidget {
  const LocalNewsScreen({super.key});

  @override
  State<LocalNewsScreen> createState() => _LocalNewsScreenState();
}

class _LocalNewsScreenState extends State<LocalNewsScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse("https://www.dailythanthi.com/tags/srivilliputhur-andal-temple"));
    //https://www.dailythanthi.com/tags/srivilliputhur
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Srivilliputhur Local News"),
        backgroundColor: Colors.redAccent,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
