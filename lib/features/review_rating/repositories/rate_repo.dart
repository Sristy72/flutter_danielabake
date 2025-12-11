import 'package:danielabake/core/network/network_result.dart';
import 'package:danielabake/features/review_rating/models/response/add_review_response_model.dart';
import '../models/request/add_review_request_model.dart';
import '../models/response/get_review_response_model.dart';

abstract class RateRepo {

  //Auth
  NetworkResult<AddReviewResponseModel> addReview(AddReviewRequestModel request);
  NetworkResult<List<GetReviewResponseModel>> getReview(String itemId);
  NetworkResult<void> deleteReview(String id);
}
