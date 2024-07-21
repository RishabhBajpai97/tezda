import 'package:flutter/material.dart';
import 'package:tezda/core/theme/colors.dart';
import 'package:tezda/features/products/domain/entity/product.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Product product =
        ModalRoute.of(context)!.settings.arguments as Product;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Details"),
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Text(
                product.title,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              Center(
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: Image.network(
                    product.image,
                    cacheHeight: 200,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              RichText(
                text: TextSpan(
                  text: 'Price :  ',
                  style: Theme.of(context).textTheme.titleMedium,
                  children: [
                    TextSpan(
                      text: "\$${product.price}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Text("${product.rating.rate} / 5 "),
                  const Icon(
                    Icons.star,
                    color: AppColors.gradient1,
                    size: 16,
                  ),
                  const Text(" by "),
                  Text(
                    "${product.rating.count} customers",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                "Description : ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(product.description),
            ],
          ),
        ),
      )),
    );
  }
}
