import 'package:flutter/material.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/models/product.dart';
import 'package:shop/widgets/products/product_grid_item.dart';

class ProductsGrid extends StatelessWidget {
  final List<Product> products;
  final int limit;
  final int? collection;

  const ProductsGrid({
    Key? key,
    this.limit = -1,
    required this.products,
    this.collection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if ((products).isEmpty) {
      return const Center(
        child: SizedBox(
          width: 200,
          height: 200,
          child: Center(
            child: UpText("No Product Available"),
          ),
        ),
      );
    } else {
      return Container(
        child: _allProductsList(context, products, collection),
      );
    }
  }
}

Widget _allProductsList(
    BuildContext context, List<Product> products, int? collection) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Wrap(
        spacing: 8,
        runSpacing: 4,
        children: products
            .map(
              (e) => ProductGridItem(product: e, collection: collection),
            )
            .toList()),
  );
}
