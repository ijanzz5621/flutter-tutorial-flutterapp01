import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StreetViewPage extends StatefulWidget {
  final double latitude;
  final double longitude;

  const StreetViewPage({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<StreetViewPage> createState() => _StreetViewPageState();
}

class _StreetViewPageState extends State<StreetViewPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    final url =
        'https://www.google.com/maps/@?api=1&map_action=pano&viewpoint=${widget.latitude},${widget.longitude}';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Street View')),
      body: WebViewWidget(controller: _controller),
    );
  }
}
