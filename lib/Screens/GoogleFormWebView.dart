import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GoogleFormWebView extends StatelessWidget {
  final String formUrl;

  GoogleFormWebView({required this.formUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Form'),
      ),
      body: WebView(
        initialUrl: formUrl,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}