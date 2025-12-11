import 'package:danielabake/core/network/api_client.dart';
import 'package:danielabake/core/network/constants/api_constants.dart';
import 'package:danielabake/core/network/network_result.dart';
import 'package:danielabake/features/review_rating/repositories/rate_repo.dart';
import '../models/request/add_review_request_model.dart';
import '../models/response/add_review_response_model.dart';
import '../models/response/get_review_response_model.dart';


class RateRepoImpl implements RateRepo {
  final ApiClient _apiClient;

  RateRepoImpl({required ApiClient apiClient}) : _apiClient = apiClient;



  @override
  NetworkResult<AddReviewResponseModel> addReview(AddReviewRequestModel request){
    return _apiClient.post(
      endpoint: ApiConstants.rating.addReview,
      data: request.toJson(),
      fromJsonT: (json) => AddReviewResponseModel.fromJson(json),
    );
  }

  @override
  NetworkResult<List<GetReviewResponseModel>> getReview(String itemId){
    return _apiClient.get(endpoint: ApiConstants.rating.getReview(itemId),
        fromJsonT: (json) => (json as List).map((item) => GetReviewResponseModel.fromJson(item)).toList());
  }

  @override
  NetworkResult<void> deleteReview(String id){
    return _apiClient.delete(
      endpoint: ApiConstants.rating.deleteReview(id),
      fromJsonT: (json) {},
    );
  }
}
