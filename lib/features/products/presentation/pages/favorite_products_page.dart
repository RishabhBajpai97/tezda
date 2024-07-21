import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tezda/core/shared/widgets/appbar.dart';
import 'package:tezda/core/shared/widgets/drawer.dart';
import 'package:tezda/core/shared/widgets/loader.dart';
import 'package:tezda/core/theme/colors.dart';
import 'package:tezda/core/utils/show_snackbar.dart';
import 'package:tezda/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:tezda/features/products/presentation/bloc/favorite_products/favorite_products_bloc.dart';
import 'package:tezda/features/products/presentation/bloc/products/products_bloc.dart';
import 'package:tezda/features/products/presentation/pages/product_details.dart';
import 'package:tezda/features/products/presentation/widgets/product_card.dart';

class FavoriteProductsPage extends StatefulWidget {
  const FavoriteProductsPage({super.key});

  @override
  State<FavoriteProductsPage> createState() => _FavoriteProductsPageState();
}

class _FavoriteProductsPageState extends State<FavoriteProductsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FavoriteProductsBloc, FavoriteProductsState>(
      listener: (context, state) {
        if (state is FavoritesError) {
          showSnackbar(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is ProductsLoading) {
          return const Loader();
        }
        return Scaffold(
          appBar: CustomAppBar(
            titleText: "Favorite Products List",
          ),
          drawer: CustomDrawer(onPressed: () {
            context.read<AuthBloc>().add(AuthLogout());
            Navigator.of(context).pushNamedAndRemoveUntil(
              "/signin",
              (route) => false,
            );
          }),
          body: BlocConsumer<FavoriteProductsBloc, FavoriteProductsState>(
            listener: (context, state) {
              if (state is FavoritesError) {
                showSnackbar(context, state.message);
              }
            },
            builder: (context, state) {
              if (state is FavoritesLoadSuccess) {
                return SafeArea(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: state.favoriteProducts.isEmpty
                      ? const Center(
                          child: Text(
                            "No Favorites added yet.....",
                            style: TextStyle(
                              color: AppColors.gradient1,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                        )
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, mainAxisSpacing: 16),
                          itemCount: state.favoriteProducts.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ProductDetailsPage(),
                                      settings: RouteSettings(
                                          arguments:
                                              state.favoriteProducts[index])),
                                );
                              },
                              child: ProductCard(
                                product: state.favoriteProducts[index],
                                iconButton: IconButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  icon: const Icon(
                                    Icons.favorite,
                                    color: AppColors.gradient2,
                                  ),
                                  onPressed: () {
                                    context.read<FavoriteProductsBloc>().add(
                                          RemoveFavoriteEvent(
                                            state.favoriteProducts[index],
                                          ),
                                        );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                ));
              }
              return const Loader();
            },
          ),
        );
      },
    );
  }
}
