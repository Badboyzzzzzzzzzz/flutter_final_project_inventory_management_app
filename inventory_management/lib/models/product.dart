class Product {
  final String name;
  final int quantity;
  final double price;
  final DateTime date;

  const Product({
    required this.name,
    required this.quantity,
    required this.price,
    required this.date,
  });

  void updateProduct(Product updatedProduct) {}
  
}
