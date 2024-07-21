import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalDataSource {
  Future<List<int>> getFavoriteProductIds();
  Future<void> cacheFavoriteProductIds(List<int> productIds);
}

class LocalDataSourceImpl implements LocalDataSource {
  static const FAVORITE_PRODUCTS_KEY = 'FAVORITE_PRODUCTS';

  final SharedPreferences sharedPreferences;

  LocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<int>> getFavoriteProductIds() {
    final favoriteIds = sharedPreferences.getStringList(FAVORITE_PRODUCTS_KEY);
    if (favoriteIds != null) {
      return Future.value(favoriteIds.map((id) => int.parse(id)).toList());
    } else {
      return Future.value([]);
    }
  }

  @override
  Future<void> cacheFavoriteProductIds(List<int> productIds) {
    final idsAsString = productIds.map((id) => id.toString()).toList();
    return sharedPreferences.setStringList(FAVORITE_PRODUCTS_KEY, idsAsString);
  }
}
