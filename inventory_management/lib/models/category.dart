import 'product.dart';
class Category {
  final String name;
  List<Product> products ;
  Category({required this.name, required this.products});
}

enum EditingMode{addProduct,editProduct}
enum SwitchMode { selection, normal}