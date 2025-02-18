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
    projectId: "hosting-test-46d7c"
    )
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
      home: const PortfolioPage(),
    );
  }
}

class PortfolioPage extends StatelessWidget {
  const PortfolioPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the URL parameter
    final uri = Uri.base;
    final pathSegments = uri.pathSegments;

    String? username;

    // Check if the URL contains `/@something` or any other username after `/@`
    if (pathSegments.isNotEmpty && pathSegments[0].startsWith('@')) {
      username = pathSegments[0].substring(1); // Remove the '@' from the username
    }

    if (username != null) {
      // Pass username to LoginForm
      return LoginPage();
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildHorizontalServices(),
            _buildProjects(),
            _buildSkills(),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }
}
  // 🔹 Header Section
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple, Colors.indigo],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/dess.jpeg'), // Add your image
          ),
          const SizedBox(height: 10),
          const Text(
            "Dessalew Fentahun",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Text(
            "Full-Stack Developer & Problem Solver",
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 8),
          const Text(
            "🎓 Graduated in Computer Science & Engineering from Adama Science & Tech University",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.white70),
          ),
          const SizedBox(height: 5),
          const Text(
            "💼 4+ Years Experience",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }

  // 🔹 Horizontal Scrolling Services Section
  Widget _buildHorizontalServices() {
    List<Map<String, dynamic>> services = [
      {"icon": Icons.code, "title": "Full-Stack Dev"},
      {"icon": Icons.phone_android, "title": "Mobile Apps"},
      {"icon": Icons.bug_report, "title": "Bug Fixing"},
      {"icon": Icons.web, "title": "Web Development"},
      {"icon": Icons.api, "title": "API Integration"},
      {"icon": Icons.settings, "title": "System Designer"},
      {"icon": Icons.design_services, "title": "UI/UX"},
      {"icon": Icons.telegram, "title": "Telegram Web App"},
      {"icon": Icons.smart_toy, "title": "Telegram Bot Dev"},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text("Services", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: services.length,
              itemBuilder: (context, index) {
                return _buildServiceCard(services[index]["icon"], services[index]["title"]);
              },
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Service Card
  Widget _buildServiceCard(IconData icon, String title) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        width: 130,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.deepPurple),
            const SizedBox(height: 8),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  // 🔹 Projects Section
  Widget _buildProjects() {
    List<String> projects = [
      "📌 GebeyaX: E-commerce (Full-Stack Developer)",
      "📌 Upwork: 6+ Completed Jobs",
      "📌 Mobile App Development (Java, Flutter)",
      "📌 Bug Fixing & Maintenance",
    ];

    return _buildSection("Worked Projects", projects);
  }

  // 🔹 Skills Section
  Widget _buildSkills() {
    List<String> skills = [
      "Java",
      "Flutter/Dart",
      "Web Development",
      "React.js",
      "Python",
      "Problem Solving",
    ];

    return _buildSection("Skills", skills);
  }

  // 🔹 Footer Section
  Widget _buildFooter(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: Colors.deepPurple,
      child: Column(
        children: [
          _buildFooterItem(Icons.email, '📧 Email: fdessalew@gmail.com', 'mailto:fdessalew@gmail.com', context),
          _buildFooterItem(Icons.link, '🔗 LinkedIn: https://www.linkedin.com/in/yaredfentahun/', 'https://www.linkedin.com/in/yaredfentahun/', context),
          _buildFooterItem(Icons.work, '💼 Upwork: https://www.upwork.com/freelancers/~01d5a40832e44e8ba1', 'https://www.upwork.com/freelancers/~01d5a40832e44e8ba1', context),
          _buildFooterItem(Icons.phone, '📞 Phone: +251988107722', 'tel:+251988107722', context), // Example for phone link
        ],
      ),
    );
  }

  Widget _buildFooterItem(IconData icon, String text, String url, BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth < 600 ? 12 : 16;

    // Function to launch URLs
    Future<void> _launchURL(String url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: GestureDetector(
        onTap: () => _launchURL(url),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white70, size: fontSize + 4),
            const SizedBox(width: 8),
            Text(text, style: TextStyle(color: Colors.white, fontSize: fontSize)),
          ],
        ),
      ),
    );
  }

  // 🔹 Reusable Section Builder
  Widget _buildSection(String title, List<String> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Column(
            children: items.map((item) => _buildCard(item)).toList(),
          ),
        ],
      ),
    );
  }

  // 🔹 Card for Projects & Skills
  Widget _buildCard(String text) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.deepPurple),
            const SizedBox(width: 10),
            Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
          ],
        ),
      ),
    );
  }


