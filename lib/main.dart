import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tezda/core/shared/cubits/app_user_cubit/app_user_cubit.dart';
import 'package:tezda/core/theme/theme.dart';
import 'package:tezda/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:tezda/features/auth/presentation/pages/login_page.dart';
import 'package:tezda/features/auth/presentation/pages/signup_page.dart';
import 'package:tezda/features/products/presentation/bloc/favorite_products/favorite_products_bloc.dart';
import 'package:tezda/features/products/presentation/bloc/products/products_bloc.dart';
import 'package:tezda/features/products/presentation/pages/favorite_products_page.dart';
import 'package:tezda/features/products/presentation/pages/products_list.dart';
import 'package:tezda/init_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => serviceLocator<AppUserCubit>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<AuthBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<ProductsBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<FavoriteProductsBloc>(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    context.read<AuthBloc>().add(AuthIsLoggedIn());
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tezda',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: BlocSelector<AppUserCubit, AppUserState, bool>(
        selector: (state) {
          return state is AppUserLoggedIn;
        },
        builder: (context, state) {
          if (state) {
            return const ProductsListPage();
          }
          return const SignIn();
        },
      ),
      routes: {
        "/signup": (context) => const Signup(),
        "/signin": (context) => const SignIn(),
        "/products-list": (context) => const ProductsListPage(),
        "/favorite-products": (context) => const FavoriteProductsPage(),
      },
    );
  }
}
