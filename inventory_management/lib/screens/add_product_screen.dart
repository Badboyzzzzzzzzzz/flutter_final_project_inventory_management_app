import 'package:flutter/material.dart';
import 'package:inventory_management/styles/color.dart';
import '../models/category.dart';
import '../models/product.dart';

class NewProduct extends StatefulWidget {
  final Function(Product) onSubmit;
  final Category category;
  final EditingMode mode;
  final Product? existingProduct;

  const NewProduct({
    super.key,
    required this.onSubmit,
    required this.category,
    required this.mode,
    this.existingProduct,
  });

  @override
  State<NewProduct> createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  final _formKey = GlobalKey<FormState>();
  late String _productName;
  late int _quantity;
  late double _price;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.mode == EditingMode.editProduct &&
        widget.existingProduct != null) {
      _productName = widget.existingProduct!.name;
      _quantity = widget.existingProduct!.quantity;
      _price = widget.existingProduct!.price;
      _selectedDate = widget.existingProduct!.date;
    } else {
      _productName = '';
      _quantity = 0;
      _price = 0.0;
      _selectedDate = null;
    }
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      final newProduct = Product(
        name: _productName,
        quantity: _quantity,
        price: _price,
        date: _selectedDate!,
      );
      widget.onSubmit(newProduct);
      Navigator.pop(context);
    }
  }

  void _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        title: Text(widget.mode == EditingMode.editProduct
            ? 'Edit Product'
            : 'New Product'),
        backgroundColor: Colors.teal,
      ),
      body: widget.mode == EditingMode.addProduct
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Product Group: ${widget.category.name}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: _productName,
                      decoration: InputDecoration(
                        labelText: 'Product Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.label),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a product name';
                        }
                        if (widget.category.products.any((product) =>
                            product.name.toLowerCase() ==
                            value.toLowerCase())) {
                          return 'Product name already exists';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _productName = value;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: _quantity.toString(),
                            decoration: InputDecoration(
                              labelText: 'Quantity',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon:
                                  const Icon(Icons.production_quantity_limits),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null ||
                                  int.tryParse(value) == null ||
                                  int.parse(value) <= 0) {
                                return 'Enter a valid positive number';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _quantity = int.tryParse(value) ?? 1;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            initialValue: _price.toString(),
                            decoration: InputDecoration(
                              labelText: 'Price',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon: const Icon(Icons.attach_money),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null ||
                                  double.tryParse(value) == null ||
                                  double.parse(value) <= 0) {
                                return 'Enter a valid positive price';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _price = double.tryParse(value) ?? 0;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _selectedDate == null
                                ? 'No date selected'
                                : 'Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        IconButton(
                          onPressed: _pickDate,
                          icon: const Icon(Icons.calendar_today),
                          tooltip: 'Pick Date',
                        ),
                      ],
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton.extended(
                        onPressed: _saveProduct,
                        backgroundColor: pacificBlue,
                        icon: const Icon(Icons.check),
                        label: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Product Group: ${widget.category.name}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: _productName,
                      decoration: InputDecoration(
                        labelText: 'Product Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.label),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a product name';
                        }

                        return null;
                      },
                      onChanged: (value) {
                        _productName = value;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: _quantity.toString(),
                            decoration: InputDecoration(
                              labelText: 'Quantity',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon:
                                  const Icon(Icons.production_quantity_limits),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null ||
                                  int.tryParse(value) == null ||
                                  int.parse(value) <= 0) {
                                return 'Enter a valid positive number';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _quantity = int.tryParse(value) ?? 1;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            initialValue: _price.toString(),
                            decoration: InputDecoration(
                              labelText: 'Price',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon: const Icon(Icons.attach_money),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null ||
                                  double.tryParse(value) == null ||
                                  double.parse(value) <= 0) {
                                return 'Enter a valid positive price';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _price = double.tryParse(value) ?? 0;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _selectedDate == null
                                ? 'No date selected'
                                : 'Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        IconButton(
                          onPressed: _pickDate,
                          icon: const Icon(Icons.calendar_today),
                          tooltip: 'Pick Date',
                        ),
                      ],
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton.extended(
                        onPressed: _saveProduct,
                        backgroundColor: pacificBlue,
                        icon: const Icon(Icons.check),
                        label: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
