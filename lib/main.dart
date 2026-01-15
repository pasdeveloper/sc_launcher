import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'services/domain_service.dart';

void main() {
  runApp(const SCLauncherApp());
}

class SCLauncherApp extends StatelessWidget {
  const SCLauncherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SC Launcher',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const RedirectorPage(),
    );
  }
}

class RedirectorPage extends StatefulWidget {
  const RedirectorPage({super.key});

  @override
  State<RedirectorPage> createState() => _RedirectorPageState();
}

class _RedirectorPageState extends State<RedirectorPage> {
  late Future<String> _domainFuture;
  final DomainFetcherService _service = DomainFetcherService();

  @override
  void initState() {
    super.initState();
    _loadDomain();
  }

  void _loadDomain() {
    setState(() {
      _domainFuture = _service.fetchActiveDomain();
    });
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not launch $url')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<String>(
          future: _domainFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text(
                    'Finding active domain...',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Unable to retrieve the link',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _loadDomain,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasData) {
              // Automatically launch URL if data is found and it's the first time
              final String url = snapshot.data!;

              // We use a post-frame callback to trigger the side effect after building
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _launchUrl(url);
              });

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  const Text('Link Found!', style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 8),
                  Text(url, style: const TextStyle(color: Colors.blue)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => _launchUrl(url),
                    child: const Text('Open in Browser'),
                  ),
                  TextButton(
                    onPressed: _loadDomain,
                    child: const Text('Check again'),
                  ),
                ],
              );
            } else {
              return const Text('Something went wrong.');
            }
          },
        ),
      ),
    );
  }
}
