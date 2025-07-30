import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/services/base/eCommerce/master_provider_base.dart';
import 'package:ready_ecommerce/utils/api_client.dart';

class MasterServiceProvider extends MasterProviderBase {
  final Ref ref;
  MasterServiceProvider(this.ref);
  @override
  Future<Response> getMasterSettings() async {
    final response =
        await ref.read(apiClientProvider).get(AppConstants.settings);
    return response;
  }
}

final masterServiceProvider = Provider((ref) => MasterServiceProvider(ref));
