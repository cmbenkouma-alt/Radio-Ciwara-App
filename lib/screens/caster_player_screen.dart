import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CasterPlayerScreen extends StatefulWidget {
  const CasterPlayerScreen({super.key});

  @override
  State<CasterPlayerScreen> createState() => _CasterPlayerScreenState();
}

class _CasterPlayerScreenState extends State<CasterPlayerScreen> {
  late final WebViewController _controller;
  int _progress = 0;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF09090B))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            if (mounted) setState(() => _progress = progress);
          },
          onWebResourceError: (error) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Erreur du lecteur Caster.fm : ${error.description}',
                ),
              ),
            );
          },
        ),
      )
      ..loadFlutterAsset('assets/caster_player.html');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lecteur Caster.fm'),
      ),
      body: Column(
        children: [
          if (_progress < 100)
            LinearProgressIndicator(value: _progress / 100),
          Expanded(
            child: WebViewWidget(controller: _controller),
          ),
        ],
      ),
    );
  }
}
