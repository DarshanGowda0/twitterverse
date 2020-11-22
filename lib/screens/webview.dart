import 'dart:io';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

class CustomView extends StatefulWidget {
  String url;

  CustomView(this.url);

  @override
  _CustomViewState createState() => _CustomViewState();
}

class _CustomViewState extends State<CustomView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebView(
          initialUrl: widget.url,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }
}
