import 'package:flutter/material.dart';
import 'category_list.dart';
import '../models/category.dart';
import '../models/product.dart';
import 'search.dart';
import '../data/category.dart';
import '../styles/color.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();

  void _addCategory(Category category) {
    setState(() {
      categories.add(category);
    });
  }

  void _removeCategory(Category category) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Category"),
        content: const Text(
          "Are you sure you want to delete this category? All products will be removed.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                categories.remove(category);
              });
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Category deleted")),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Collect all products from categories for search
    final List<Product> allProducts =
        categories.expand((category) => category.products).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Homepage'),
        backgroundColor: pacificBlue,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProductSearchDelegate(categories),
              );
            },
            icon: const Icon(Icons.search),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: categories.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.category, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "No categories available",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 2,
                ),
                itemCount: categories.length,
                itemBuilder: (ctx, index) {
                  final category = categories[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => CategoryPage(
                            category: categories[index],
                            onCategoryUpdated: () {
                              setState(
                                  () {}); // Force rebuild to reflect changes
                            },
                          ),
                        ),
                      );
                    },
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              category.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${category.products.length} products',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    onLongPress: () => _removeCategory(category),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) {
              final TextEditingController controller = TextEditingController();
              return AlertDialog(
                title: const Text('Add New Category'),
                content: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: controller,
                    decoration: const InputDecoration(
                      labelText: 'Category Name',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a category name';
                      }
                      if (categories.any((category) =>
                          category.name.toLowerCase() ==
                          value.trim().toLowerCase())) {
                        return 'Category already exists';
                      }
                      return null;
                    },
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _addCategory(
                          Category(
                            name: controller.text.trim(),
                            products: [],
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.teal,
                    ),
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: pacificBlue,
        icon: const Icon(Icons.add),
        label: const Text("Add Category"),
      ),
    );
  }
}
