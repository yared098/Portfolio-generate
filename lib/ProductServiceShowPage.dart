import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductServiceShowPage extends StatefulWidget {
  final String userId;

  const ProductServiceShowPage({Key? key, required this.userId}) : super(key: key);

  @override
  _ProductServiceShowPageState createState() => _ProductServiceShowPageState();
}

class _ProductServiceShowPageState extends State<ProductServiceShowPage> {
  bool isLoading = true;
  String errorMessage = '';
  List products = [];
  List services = [];
  List filteredProducts = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final productRef = FirebaseFirestore.instance.collection('products');
    final serviceRef = FirebaseFirestore.instance.collection('services');

    try {
      // Fetch Products based on userId
      final productSnapshot = await productRef.where('userId', isEqualTo: widget.userId).get();
      if (productSnapshot.docs.isNotEmpty) {
        products = productSnapshot.docs.map((doc) => doc.data()).toList();
        filteredProducts = products; // Initially, show all products
      } else {
        throw 'No products found for this user.';
      }

      // Fetch Services based on userId
      final serviceSnapshot = await serviceRef.where('userId', isEqualTo: widget.userId).get();
      if (serviceSnapshot.docs.isNotEmpty) {
        services = serviceSnapshot.docs.map((doc) => doc.data()).toList();
      } else {
        throw 'No services found for this user.';
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterProducts(String query) {
    if (query.isNotEmpty) {
      setState(() {
        filteredProducts = products
            .where((product) =>
                product['name'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    } else {
      setState(() {
        filteredProducts = products;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products and Services'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text('Error: $errorMessage'))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSearchBar(),
                        if (_searchController.text.isEmpty)
                          ...[
                            _buildSectionTitle('Services'),
                            _buildServiceList(),
                          ],
                        _buildSectionTitle('Products'),
                        _buildProductGrid(),
                      ],
                    ),
                  ),
                ),
    );
  }

  // Search Bar at the top with border radius
  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.grey[200],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          hintText: 'Search products...',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        ),
        onChanged: (query) {
          _filterProducts(query); // Call filtering function when search text changes
        },
      ),
    );
  }

  // GridView for Products
  Widget _buildProductGrid() {
    return GridView.builder(
      shrinkWrap: true,  // Prevents GridView from taking full height
      physics: NeverScrollableScrollPhysics(),  // Prevent scrolling
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,  // Number of columns in grid
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.75,  // Adjust product card size
      ),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        return Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Image.network(product['image'], fit: BoxFit.cover),  // Add image URL
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  product['name'],
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('\$${product['price']}'),
              ),
            ],
          ),
        );
      },
    );
  }

  // Horizontal ListView for Services
  Widget _buildServiceList() {
    return Container(
      height: 250,  // Increased height for better spacing
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return Card(
            margin: EdgeInsets.only(right: 16),
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              width: 180,  // Slightly wider card for better layout
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(blurRadius: 6, color: const Color.fromARGB(66, 236, 233, 233))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // You can uncomment and add an image if you want
                  // Image.network(service['image'], fit: BoxFit.cover),
                  SizedBox(height: 8),
                  Text(
                    service['name'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 4),
                  Text(
                    service['description'],
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Section Title
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
