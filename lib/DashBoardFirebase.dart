import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
class DashboardPage extends StatefulWidget {
  final String userId;  // Accept userId as a parameter

  const DashboardPage({super.key, required this.userId});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> services = [];
  List<Map<String, dynamic>> products = [];
  final uri = Uri.base;
    var pathSegments="";

  @override
  void initState() {
    super.initState();
    _fetchServices();
    _fetchProducts();
    pathSegments=uri.pathSegments as String;
  }

  // Fetch services specific to the userId
  Future<void> _fetchServices() async {
    final snapshot = await _firestore
        .collection('services')
        .where('userId', isEqualTo: widget.userId)  // Filter by userId
        .get();

    setState(() {
      services = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  // Fetch products specific to the userId
  Future<void> _fetchProducts() async {
    final snapshot = await _firestore
        .collection('products')
        .where('userId', isEqualTo: widget.userId)  // Filter by userId
        .get();

    setState(() {
      products = snapshot.docs.map((doc) => {
        ...doc.data(),
        'id': doc.id,  // Add document ID to each product
      }).toList();
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
              const Text('Update Service', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Service Title')),
              const SizedBox(height: 8),
              TextField(controller: descController, decoration: const InputDecoration(labelText: 'Service Description')),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (titleController.text.isNotEmpty && descController.text.isNotEmpty) {
                    await _firestore.collection('services').doc(service['id']).update({
                      "name": titleController.text,
                      "description": descController.text,
                      "userId": widget.userId,  // Add userId to the service
                    });
                    _fetchServices();
                    Navigator.pop(context);
                  }
                },
                child: const Text('Update Service'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _firestore.collection('services').doc(service['id']).delete();
                  _fetchServices();
                  Navigator.pop(context);
                },
                child: const Text('Delete Service', style: TextStyle(color: Colors.red)),
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
              const Text('Update Product', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Product Name')),
              const SizedBox(height: 8),
              TextField(controller: priceController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Product Price')),
              const SizedBox(height: 8),
              TextField(controller: descController, decoration: const InputDecoration(labelText: 'Product Description')),
              const SizedBox(height: 8),
              TextField(controller: imageController, decoration: const InputDecoration(labelText: 'Product Image URL')),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (nameController.text.isNotEmpty && priceController.text.isNotEmpty && descController.text.isNotEmpty && imageController.text.isNotEmpty) {
                    await _firestore.collection('products').doc(product['id']).update({
                      "name": nameController.text,
                      "price": double.tryParse(priceController.text),
                      "description": descController.text,
                      "image": imageController.text,
                      "userId": widget.userId,  // Add userId to the product
                    });
                    _fetchProducts();
                    Navigator.pop(context);
                  }
                },
                child: const Text('Update Product'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _firestore.collection('products').doc(product['id']).delete();
                  _fetchProducts();
                  Navigator.pop(context);
                },
                child: const Text('Delete Product', style: TextStyle(color: Colors.red)),
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
              const Text('Add New Product', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Product Name')),
              const SizedBox(height: 8),
              TextField(controller: priceController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Product Price')),
              const SizedBox(height: 8),
              TextField(controller: descController, decoration: const InputDecoration(labelText: 'Product Description')),
              const SizedBox(height: 8),
              TextField(controller: imageController, decoration: const InputDecoration(labelText: 'Product Image URL')),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (nameController.text.isNotEmpty && priceController.text.isNotEmpty && descController.text.isNotEmpty && imageController.text.isNotEmpty) {
                    await _firestore.collection('products').add({
                      "name": nameController.text,
                      "price": double.tryParse(priceController.text),
                      "description": descController.text,
                      "image": imageController.text,
                      "userId": widget.userId,  // Add userId to the product
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
  

  @override
  Widget build(BuildContext context) {
     
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard'), backgroundColor: Colors.deepPurple),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildServicesList(),
            const SizedBox(height: 16),
            _buildProductsGrid(),
            _buildFooter(context,pathSegments.toString(),widget.userId,),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddProductBottomSheet,
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ),
    );
  }
  // 🔹 Footer Section
Widget _buildFooter(BuildContext context, String url, String userid) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    color: Colors.deepPurple,
    child: Column(
      children: [
        _buildFooterItem(Icons.public, "Publick link","📧 $url/$userid",),
        
      ],
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
              const Text('Add New Service', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Service Title')),
              const SizedBox(height: 8),
              TextField(controller: descController, decoration: const InputDecoration(labelText: 'Service Description')),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (titleController.text.isNotEmpty && descController.text.isNotEmpty) {
                    // Add new service to Firestore
                    await _firestore.collection('services').add({
                      "name": titleController.text,
                      "description": descController.text,
                      "userId": widget.userId,  // Add userId to the service
                    });
                    _fetchServices();
                    Navigator.pop(context);  // Close bottom sheet
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
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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
          crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10,
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
    return GestureDetector(
      onTap: () => _showProductBottomSheet(product),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(imageUrl, height: 120, width: double.infinity, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                product["name"] ?? "Unknown Product",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Price: \$${product['price']}"),
            ),
          ],
        ),
      ),
    );
  }
   Widget _buildFooterItem(IconData icon, String text, String url) {
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

}

