import 'package:flutter/material.dart';
import 'package:inventory_management/screens/add_product_screen.dart';
import '../models/category.dart';

class ProductSearchDelegate extends SearchDelegate {
  final List<Category> categories; // List of categories passed in
  ProductSearchDelegate(this.categories);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = ''; 
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final filteredProducts = categories
        .expand((category) => category.products)
        .where((product) =>
            product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return filteredProducts.isEmpty
        ? Center(
            child: Text(
              'No results found for "$query"',
              style: const TextStyle(fontSize: 18),
            ),
          )
        : ListView.builder(
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              final product = filteredProducts[index];
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(product.name,style:const TextStyle(fontWeight: FontWeight.bold),),
                  subtitle: Text('${product.price}\$ - ${product.quantity} available'),
                  trailing: Text('${product.date.toLocal()}'.split(' ')[0]),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewProduct(
                          onSubmit: (updatedProduct) {
                            categories
                                .expand((category) => category.products)
                                .firstWhere((p) => p.quantity == product.quantity)
                                .updateProduct(updatedProduct); // Update logic
                          },
                          category: categories
                              .firstWhere((category) => category.products.contains(product)),
                          mode: EditingMode.editProduct,
                          existingProduct: product,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final filteredProducts = categories
        .expand((category) => category.products)
        .where((product) =>
            product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return filteredProducts.isEmpty
        ? Center(
            child: Text(
              'No suggestions for "$query"',
              style: const TextStyle(fontSize: 18),
            ),
          )
        : ListView.builder(
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              final product = filteredProducts[index];
              return ListTile(
                title: Text(product.name),
                subtitle: Text('${product.price}\$ - ${product.quantity} available'),
                onTap: () {
                  query = product.name; 
                  showResults(context); 
                },
              );
            },
          );
  }
}
