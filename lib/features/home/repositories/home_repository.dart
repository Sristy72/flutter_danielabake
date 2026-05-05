import 'package:danielabake/features/home/models/response/get_popular_items_response_model.dart';

import '../../../core/network/network_result.dart';

abstract class HomeRepository {
  NetworkResult<GetPopularItemResponseModel> fetchPopularItems(String day);
  NetworkResult<GetPopularItemResponseModel> fetchAllPopularItems({int page = 1, int limit = 10});
}
