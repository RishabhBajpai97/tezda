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

class ProductsListPage extends StatefulWidget {
  const ProductsListPage({super.key});

  @override
  State<ProductsListPage> createState() => _ProductsListPageState();
}

class _ProductsListPageState extends State<ProductsListPage> {
  @override
  void initState() {
    context.read<FavoriteProductsBloc>().add(LoadFavoritesEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthBlocState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          showSnackbar(context, state.message);
        } else if (state is AuthInitial) {
          Navigator.of(context).pushReplacementNamed("/signin");
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Loader();
        }
        return Scaffold(
          appBar: CustomAppBar(titleText: "Products List",),
          drawer: CustomDrawer(onPressed: () {
            context.read<AuthBloc>().add(AuthLogout());
            Navigator.of(context).pushNamedAndRemoveUntil(
              "/signin",
              (route) => false,
            );
          }),
          body: BlocConsumer<ProductsBloc, ProductsState>(
            listener: (context, state) {
              if (state is ProductsFailure) {
                showSnackbar(context, state.message);
              }
            },
            builder: (context, state) {
              if (state is ProductsSuccess) {
                return SafeArea(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, mainAxisSpacing: 16),
                    itemCount: state.products.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ProductDetailsPage(),
                                settings: RouteSettings(
                                    arguments: state.products[index])),
                          );
                        },
                        child: ProductCard(
                          product: state.products[index],
                          iconButton: IconButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            icon: BlocBuilder<FavoriteProductsBloc,
                                FavoriteProductsState>(
                              builder: (context, favstate) {
                                final isFavorite =
                                    favstate is FavoritesLoadSuccess &&
                                        favstate.favoriteProducts.any((p) =>
                                            p.id == state.products[index].id);
                                return Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavorite
                                      ? AppColors.gradient2
                                      : AppColors.gradient1,
                                );
                              },
                            ),
                            onPressed: () {
                              final isFavorite = context
                                      .read<FavoriteProductsBloc>()
                                      .state is FavoritesLoadSuccess &&
                                  (context.read<FavoriteProductsBloc>().state
                                          as FavoritesLoadSuccess)
                                      .favoriteProducts
                                      .any((p) =>
                                          p.id == state.products[index].id);

                              context.read<FavoriteProductsBloc>().add(
                                    isFavorite
                                        ? RemoveFavoriteEvent(
                                            state.products[index])
                                        : AddFavoriteEvent(
                                            state.products[index]),
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
