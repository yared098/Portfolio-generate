import 'package:fhost/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardPage extends StatefulWidget {
  final String userId; // Accept userId as a parameter

  const DashboardPage({super.key, required this.userId});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> services = [];
  List<Map<String, dynamic>> products = [];

  String baseUrl = ''; // To store the base URL
  String pathAfterAt = ''; // To store the path after /@

  @override
  void initState() {
    super.initState();
    _fetchServices();
    _fetchProducts();

    final uri = Uri.base;
    setState(() {
      // Set the base URL (scheme + host + port)
      baseUrl = uri.origin;

      // Check if path contains "/@"
      if (uri.path.contains('/@')) {
        // Extract everything after "/@"
        final indexOfAt = uri.path.indexOf('/@');
        pathAfterAt =
            uri.path.substring(indexOfAt + 1); // Get everything after "/@"
      } else {
        pathAfterAt = uri.path; // If "/@" is not present, show the whole path
      }
    });
  }

  // Fetch services specific to the userId
  Future<void> _fetchServices() async {
    final snapshot = await _firestore
        .collection('services')
        .where('userId', isEqualTo: widget.userId) // Filter by userId
        .get();

    setState(() {
      services = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  // Fetch products specific to the userId
  Future<void> _fetchProducts() async {
    final snapshot = await _firestore
        .collection('products')
        .where('userId', isEqualTo: widget.userId) // Filter by userId
        .get();

    setState(() {
      products = snapshot.docs
          .map((doc) => {
                ...doc.data(),
                'id': doc.id, // Add document ID to each product
              })
          .toList();
    });
  }

  void _showServiceBottomSheet(Map<String, dynamic> service) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descController = TextEditingController();
    titleController.text = service["name"];
    descController.text = service["description"] ?? "";

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Update Service',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                  controller: titleController,
                  decoration:
                      const InputDecoration(labelText: 'Service Title')),
              const SizedBox(height: 8),
              TextField(
                  controller: descController,
                  decoration:
                      const InputDecoration(labelText: 'Service Description')),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (titleController.text.isNotEmpty &&
                      descController.text.isNotEmpty) {
                    await _firestore
                        .collection('services')
                        .doc(service['id'])
                        .update({
                      "name": titleController.text,
                      "description": descController.text,
                      "userId": widget.userId, // Add userId to the service
                    });
                    _fetchServices();
                    Navigator.pop(context);
                  }
                },
                child: const Text('Update Service'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _firestore
                      .collection('services')
                      .doc(service['id'])
                      .delete();
                  _fetchServices();
                  Navigator.pop(context);
                },
                child: const Text('Delete Service',
                    style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showProductBottomSheet(Map<String, dynamic> product) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController descController = TextEditingController();
    final TextEditingController imageController = TextEditingController();

    nameController.text = product["name"];
    priceController.text = product["price"].toString();
    descController.text = product["description"];
    imageController.text = product["image"];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Update Product',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Product Name')),
              const SizedBox(height: 8),
              TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'Product Price')),
              const SizedBox(height: 8),
              TextField(
                  controller: descController,
                  decoration:
                      const InputDecoration(labelText: 'Product Description')),
              const SizedBox(height: 8),
              TextField(
                  controller: imageController,
                  decoration:
                      const InputDecoration(labelText: 'Product Image URL')),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (nameController.text.isNotEmpty &&
                      priceController.text.isNotEmpty &&
                      descController.text.isNotEmpty &&
                      imageController.text.isNotEmpty) {
                    await _firestore
                        .collection('products')
                        .doc(product['id'])
                        .update({
                      "name": nameController.text,
                      "price": double.tryParse(priceController.text),
                      "description": descController.text,
                      "image": imageController.text,
                      "userId": widget.userId, // Add userId to the product
                    });
                    _fetchProducts();
                    Navigator.pop(context);
                  }
                },
                child: const Text('Update Product'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _firestore
                      .collection('products')
                      .doc(product['id'])
                      .delete();
                  _fetchProducts();
                  Navigator.pop(context);
                },
                child: const Text('Delete Product',
                    style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddProductBottomSheet() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController descController = TextEditingController();
    final TextEditingController imageController = TextEditingController();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add New Product',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Product Name')),
              const SizedBox(height: 8),
              TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'Product Price')),
              const SizedBox(height: 8),
              TextField(
                  controller: descController,
                  decoration:
                      const InputDecoration(labelText: 'Product Description')),
              const SizedBox(height: 8),
              TextField(
                  controller: imageController,
                  decoration:
                      const InputDecoration(labelText: 'Product Image URL')),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (nameController.text.isNotEmpty &&
                      priceController.text.isNotEmpty &&
                      descController.text.isNotEmpty &&
                      imageController.text.isNotEmpty) {
                    await _firestore.collection('products').add({
                      "name": nameController.text,
                      "price": double.tryParse(priceController.text),
                      "description": descController.text,
                      "image": imageController.text,
                      "userId": widget.userId, // Add userId to the product
                    });
                    _fetchProducts();
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add Product'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _logout(BuildContext context) async {
    try {
      // Sign out from Firebase
      await FirebaseAuth.instance.signOut();

      // Clear shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Navigate back to the login page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (e) {
      print("Logout Error: $e");
    }
  }

 // Reusable function to copy any URL to clipboard
  void _copyToClipboard(String url, String pathtype) {
    Clipboard.setData(ClipboardData(text: url)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Header: URL Copied!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 5),
              Text(
                '$pathtype\n$url',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Admin'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildServicesList(),
            const SizedBox(height: 16),
            _buildProductsGrid(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddProductBottomSheet,
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.deepPurple[50],  // Light color for the BottomAppBar
        child: Column(
          children: [
            // Public URL Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 6.0),
              child: GestureDetector(
                onTap: () => _copyToClipboard('$baseUrl/$pathAfterAt', "Private"), // Copy Public URL
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.link, color: Colors.blue),
                    Text(
                      'Private URL: $baseUrl/$pathAfterAt',  // Display Public URL
                      style: TextStyle(fontSize: 14, color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.copy, color: Colors.blue),
                  ],
                ),
              ),
            ),
            // Private URL Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 6.0),
              child: GestureDetector(
                onTap: () => _copyToClipboard('$baseUrl/-${widget.userId}', "Public"), // Copy Private URL
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.link, color: Colors.green),
                    Text(
                      'Public URL: $baseUrl/-${widget.userId}',  // Display Private URL
                      style: TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.copy, color: Colors.green),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesList() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: services.length + 1, // Always include the add card
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildAddServiceCard();
          }
          return _buildServiceCard(services[index - 1]);
        },
      ),
    );
  }

  // Update this method to show the Add Service Bottom Sheet
  Widget _buildAddServiceCard() {
    return GestureDetector(
      onTap: () {
        // Show the bottom sheet for adding a new service and pass the userId
        _showAddServiceBottomSheet();
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Icon(Icons.add, size: 40, color: Colors.deepPurple),
        ),
      ),
    );
  }

  // Add a new service method with userId
  void _showAddServiceBottomSheet() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descController = TextEditingController();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add New Service',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                  controller: titleController,
                  decoration:
                      const InputDecoration(labelText: 'Service Title')),
              const SizedBox(height: 8),
              TextField(
                  controller: descController,
                  decoration:
                      const InputDecoration(labelText: 'Service Description')),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (titleController.text.isNotEmpty &&
                      descController.text.isNotEmpty) {
                    // Add new service to Firestore
                    await _firestore.collection('services').add({
                      "name": titleController.text,
                      "description": descController.text,
                      "userId": widget.userId, // Add userId to the service
                    });
                    _fetchServices();
                    Navigator.pop(context); // Close bottom sheet
                  }
                },
                child: const Text('Add Service'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    return GestureDetector(
      onTap: () => _showServiceBottomSheet(service),
      child: Card(
        color: Colors.deepPurple,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                service["name"] ?? "Unknown Service",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              if (service["description"] != null)
                Text(
                  service["description"],
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
            ],
          ),
        ),
      ),
    );
  }
  
 Widget _buildProductsGrid() {
  return Expanded(
    child: GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final imageUrl = products[index]["image"]?.isNotEmpty == true
            ? products[index]["image"]
            : 'https://via.placeholder.com/150';
        return _buildProductCard(products[index], imageUrl);
      },
    ),
  );
}

Widget _buildProductCard(Map<String, dynamic> product, String imageUrl) {
  return Card(
    elevation: 4.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    child: LayoutBuilder(
      builder: (context, constraints) {
        // Calculate the appropriate heights based on screen size
        double imageHeight = constraints.maxHeight / 2;
        if (MediaQuery.of(context).size.width < 600) {
          // On small screens, image takes half of the card height
          imageHeight = constraints.maxHeight / 2;
        } else {
          // On large screens, card height is halved and image adjusts
          imageHeight = constraints.maxHeight / 2;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with dynamic height
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.network(
                imageUrl,
                height: imageHeight,  // Dynamically set height based on screen size
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Title
                  Text(
                    product["name"] ?? 'Unknown Product',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  // Product Description (optional)
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 40, // Limit the height of the description
                    ),
                    child: Text(
                      product["description"] ?? 'No description available.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    ),
  );
}

}