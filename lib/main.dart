import 'package:fhost/ProductServiceShowPage.dart';
import 'package:fhost/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDNUQ-obBntLJrlU8e_XpbIwh8ReA0a2wI",
      appId: "1:188102003559:web:fe121fc28f1ff9782cfdc2",
      messagingSenderId: "188102003559",
      projectId: "hosting-test-46d7c",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Portfolio',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final uri = Uri.base;
    final pathSegments = uri.pathSegments;

    String? username;
    String? userId;

    if (pathSegments.isNotEmpty) {
      final segment = pathSegments[0];
      if (segment.startsWith('@')) {
        username = segment.substring(1);
      } else if (segment.startsWith('-')) {
        userId = segment.substring(1);
      }
    }

    if (username != null) {
      return LoginPage();
    }
    if (userId != null) {
      return ProductServiceShowPage(userId: userId);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Small Business Builder'),
        actions: [
          IconButton(
            icon: const Icon(Icons.login),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Free Small Business Builder',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Start your own business today. Easily manage products, services, and grow your startup!',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to Create Your Own Business page (can add this page later)
                _showCreateBusinessPage(context);
              },
              child: const Text('Create Your Own Business'),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            const Text(
              'About Our Startup:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'We are a small startup dedicated to helping entrepreneurs grow their business. Our platform provides tools to build, manage, and scale your business easily. Join us and take the next step in your entrepreneurial journey!',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateBusinessPage(BuildContext context) {
    // This method will show the page to create a new business, which you can implement later.
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create Your Business'),
          content: const Text(
              'This feature will allow you to create a new business profile and manage it.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: const Text('Start Creating'),
            ),
          ],
        );
      },
    );
  }
}
