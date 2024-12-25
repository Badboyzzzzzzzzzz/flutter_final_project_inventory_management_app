import 'package:flutter/material.dart';
import 'package:inventory_management/styles/color.dart';

import '../models/product.dart';
import '../models/category.dart';
import 'add_product_screen.dart';

class CategoryPage extends StatefulWidget {
  final Category category;
  final Function() onCategoryUpdated;

  const CategoryPage({
    super.key,
    required this.category,
    required this.onCategoryUpdated,
  });

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  SwitchMode? currentState = SwitchMode.normal;
  Set<Product> selectedItems = {};

  void _addProduct(Product newProduct) {
    setState(() {
      widget.category.products.add(newProduct);
    });
    widget.onCategoryUpdated();
  }

  void _editProduct(int index, Product updatedProduct) {
    setState(() {
      widget.category.products[index] = updatedProduct;
    });
    widget.onCategoryUpdated();
  }
 

  void _navigateToNewProduct() {
    Navigator.push<Product>(
      context,
      MaterialPageRoute(
        builder: (context) => NewProduct(
          onSubmit: _addProduct,
          category: widget.category,
          mode: EditingMode.addProduct,
        ),
      ),
    );
  }

  void _navigateToEditing(int index) {
    Navigator.push<Product>(
      context,
      MaterialPageRoute(
        builder: (context) => NewProduct(
          onSubmit: (updatedProduct) => _editProduct(index, updatedProduct),
          category: widget.category,
          mode: EditingMode.editProduct,
          existingProduct: widget.category.products[index],
        ),
      ),
    );
  }

  void _setToSelectionMode() {
    setState(() {
      currentState = SwitchMode.selection;
    });
  }

  void _setToNormalMode() {
    setState(() {
      selectedItems.clear();
      currentState = SwitchMode.normal;
    });
  }

  void _itemSelected(Product item) {
    setState(() {
      if (selectedItems.contains(item)) {
        selectedItems.remove(item);
      } else {
        selectedItems.add(item);
      }
    });
  }

  void _removeProduct(Product product) {
    final List<Product> deletedProduct = List.from(selectedItems);
    setState(() {
      widget.category.products
          .removeWhere((product) => selectedItems.contains(product));
      selectedItems.clear();
    });
    widget.onCategoryUpdated();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Selected Product(s) have been deleted.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              widget.category.products.addAll(deletedProduct);
            });
            widget.onCategoryUpdated();
          },
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSelectionMode = currentState == SwitchMode.selection;
    final productList = widget.category.products;

    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        title: Text(
          isSelectionMode
              ? '${selectedItems.length} Selected'
              : widget.category.name,
        ),
        leading: isSelectionMode
            ? IconButton(
                onPressed: _setToNormalMode,
                icon: const Icon(Icons.arrow_back),
              )
            : null,
        backgroundColor: pacificBlue,
      ),
      body: productList.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "No products added yet.",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: productList.length,
                itemBuilder: (ctx, index) {
                  final product = productList[index];
                  final isSelected = selectedItems.contains(product);

                  return Dismissible(
                    key: Key(product.quantity.toString()), 
                    direction:DismissDirection.endToStart, 
                    onDismissed: (direction) {
                      setState(() {
                        widget.category.products.removeAt(index);
                      });
                      widget.onCategoryUpdated();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Product has been deleted.'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {
                              setState(() {
                                widget.category.products.insert(index, product);
                              });
                              widget.onCategoryUpdated();
                            },
                          ),
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete,
                          color: Colors.white, size: 40),
                    ),
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: isSelected ? Colors.lightBlue[50] : Colors.white,
                      child: ListTile(
                        leading: isSelectionMode
                            ? Checkbox(
                                value: isSelected,
                                onChanged: (_) => _itemSelected(product),
                              )
                            : const Icon(Icons.inventory),
                        title: Text(product.name,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          '\$${product.price} - ${product.quantity} available',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        trailing: Text(
                          '${product.date.toLocal()}'.split(' ')[0],
                          style: const TextStyle(color: Colors.blueGrey),
                        ),
                        onLongPress:
                            _setToSelectionMode, // Trigger selection mode on long press
                        onTap: () => isSelectionMode
                            ? _itemSelected(product)
                            : _navigateToEditing(index),
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: isSelectionMode
          ? FloatingActionButton.extended(
              onPressed: () => selectedItems.forEach(_removeProduct),
              backgroundColor: Colors.red,
              icon: const Icon(Icons.delete),
              label: const Text("Delete"),
            )
          : FloatingActionButton.extended(
              onPressed: _navigateToNewProduct,
              backgroundColor: pacificBlue,
              icon: const Icon(Icons.add),
              label: const Text("Add Product"),
            ),
    );
  }
}
