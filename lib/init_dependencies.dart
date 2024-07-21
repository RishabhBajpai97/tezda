import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import "package:http/http.dart" as http;
import 'package:tezda/core/secrets/app_secrets.dart';
import 'package:tezda/core/shared/cubits/app_user_cubit/app_user_cubit.dart';
import 'package:tezda/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:tezda/features/auth/data/repository/auth_repository_impl.dart';
import 'package:tezda/features/auth/domain/repository/auth_repository.dart';
import 'package:tezda/features/auth/domain/usecase/current_user.dart';
import 'package:tezda/features/auth/domain/usecase/login_user.dart';
import 'package:tezda/features/auth/domain/usecase/signup_user.dart';
import 'package:tezda/features/auth/domain/usecase/user_logout.dart';
import 'package:tezda/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:tezda/features/products/data/datasource/local_data_source.dart';
import 'package:tezda/features/products/data/datasource/product_remote_source.dart';
import 'package:tezda/features/products/data/repository/product_repository_impl.dart';
import 'package:tezda/features/products/domain/repository/product_repository.dart';
import 'package:tezda/features/products/domain/usecase/get_favorite_products.dart';
import 'package:tezda/features/products/domain/usecase/get_products.dart';
import 'package:tezda/features/products/domain/usecase/set_favorite_products.dart';
import 'package:tezda/features/products/presentation/bloc/favorite_products/favorite_products_bloc.dart';
import 'package:tezda/features/products/presentation/bloc/products/products_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final supabase =
      await Supabase.initialize(anonKey: AppSecrets.anon, url: AppSecrets.url);
  serviceLocator.registerLazySingleton(() => supabase.client);
  serviceLocator.registerLazySingleton(() => AppUserCubit());
  serviceLocator.registerLazySingleton(() => http.Client());
  serviceLocator.registerFactory<LocalDataSource>(
      () => LocalDataSourceImpl(sharedPreferences: serviceLocator()));

  serviceLocator.registerLazySingleton(() => sharedPreferences);

  _initAuth();
  _initProducts();
}

void _initAuth() {
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserSignup(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserLogin(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserLogout(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => CurrentUser(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => AuthBloc(
          userSignup: serviceLocator(),
          userLogin: serviceLocator(),
          currentUser: serviceLocator(),
          appUserCubit: serviceLocator(),
          userLogout: serviceLocator()),
    );
}

_initProducts() {
  serviceLocator
      .registerLazySingleton(() => ProductsBloc(getProducts: serviceLocator()));
  serviceLocator.registerLazySingleton(() => FavoriteProductsBloc(
      getFavoriteProducts: serviceLocator(),
      setFavoriteProducts: serviceLocator()));
  serviceLocator.registerFactory(() => GetFavoriteProducts(serviceLocator()));
  serviceLocator.registerFactory(() => SetFavoriteProducts(serviceLocator()));
  serviceLocator.registerFactory(() => GetProducts(serviceLocator()));
  serviceLocator.registerFactory<ProductRepository>(
      () => ProductRepositoryImpl(serviceLocator(), serviceLocator()));
  serviceLocator.registerFactory<ProductRemoteSource>(
    () => ProductRemoteSourceImpl(
      serviceLocator(),
    ),
  );
}
