import 'package:dio/dio.dart';
import 'package:ready_ecommerce/models/eCommerce/common/product_filter_model.dart';

abstract class ProductProviderBase {
  Future<Response> getCategoryWiseProducts(
      {required ProductFilterModel productFilterModel});
  Future<Response> getProductDetails({required int productId});
  Future<Response> favoriteProductAddRemove({required int productId});
  Future<Response> getFavoriteProducts();
}
