import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tezda/core/shared/cubits/app_user_cubit/app_user_cubit.dart';
import 'package:tezda/core/theme/colors.dart';
import 'package:tezda/features/auth/presentation/widgets/auth_gradient_button.dart';

class CustomDrawer extends StatelessWidget {
  final VoidCallback onPressed;
  const CustomDrawer({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<AppUserCubit, AppUserState>(
                  builder: (context, state) {
                    if (state is AppUserLoggedIn) {
                      return Text(
                        state.user.email,
                        style: const TextStyle(
                          fontSize: 20,
                          color: AppColors.gradient2,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }
                    return const Text("");
                  },
                ),
                const SizedBox(
                  height: 50,
                ),
                ListTile(
                  title: const Text("All Products"),
                  trailing: const Icon(Icons.shopping_bag),
                  onTap: () {
                    Navigator.of(context).pushNamed("/products-list");
                  },
                ),
                ListTile(
                  title: const Text("Favorites"),
                  trailing: const Icon(Icons.favorite),
                  onTap: () {
                    Navigator.of(context).pushNamed("/favorite-products");
                  },
                ),
                const SizedBox(
                  height: 50,
                ),
                AuthGradientButton(buttonText: "Logout", onPressed: onPressed)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
