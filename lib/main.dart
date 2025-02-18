// import 'package:fhost/ProductServiceShowPage.dart';
// import 'package:fhost/login.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';


// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: FirebaseOptions(
//     apiKey: "AIzaSyDNUQ-obBntLJrlU8e_XpbIwh8ReA0a2wI", 
//     appId: "1:188102003559:web:fe121fc28f1ff9782cfdc2", 
//     messagingSenderId: "188102003559", 
//     projectId: "hosting-test-46d7c"
//     )
//   );
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'My Portfolio',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       // home: const HomePage(),
//       home: const ProductServiceShowPage(userId: "fRQQ9XtN3cVdqypBCtWUN8jEnph2",),
//     );
//   }
// }
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
  
//   @override
//   Widget build(BuildContext context) {
//      // Get the URL parameter
//     final uri = Uri.base;
//     final pathSegments = uri.pathSegments;

//     String? username;
//     String ?userid; // this is to make fetch the searvices and products 

//     // Check if the URL contains `/@something` or any other username after `/@`
//     if (pathSegments.isNotEmpty && pathSegments[0].startsWith('@')) {
//       username = pathSegments[0].substring(1); // Remove the '@' from the username
//     }else if(pathSegments.isNotEmpty && pathSegments[0].startsWith('#'))
//     {
//       userid=pathSegments[0].substring(1);

//     }
//     if (username != null) {
//       // Pass username to LoginForm
//       return LoginPage();
//     }
//     if(userid!=null)
//     {
//       return ProductServiceShowPage(userId: "fRQQ9XtN3cVdqypBCtWUN8jEnph2");
//     }
//     return const Placeholder();
//   }
// }


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
    
    return const Placeholder();
  }
}
