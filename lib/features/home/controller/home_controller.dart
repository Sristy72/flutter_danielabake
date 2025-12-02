import 'dart:developer' as DPrint;
import 'package:danielabake/features/home/models/response/get_category_response_model.dart';
import 'package:danielabake/features/home/models/response/get_popular_items_response_model.dart';
import 'package:danielabake/features/home/models/response/search_response_model.dart';
import 'package:danielabake/features/home/repositories/home_repository.dart';
import 'package:danielabake/features/home/repositories/search_repository.dart';
import 'package:get/get.dart';
import '../../../../core/base/base_controller.dart';
import '../../../core/network/services/auth_storage_service.dart';

class HomeController extends BaseController {
  final _homeRepository = Get.find<HomeRepository>();
  final _searchRepository = Get.find<SearchRepository>();
  final AuthStorageService _authStorageService = AuthStorageService();

  // Category
  final Rxn<GetCategoryResponseModel> category = Rxn<GetCategoryResponseModel>();

  // Popular items (default list)
  final Rxn<GetPopularItemResponseModel> popularItem =
  Rxn<GetPopularItemResponseModel>();

  // Search results
  final Rxn<GetPopularItemResponseModel> search =
  Rxn<GetPopularItemResponseModel>();

  @override
  void onInit() {
    super.onInit();
    fetchPopularItem();
  }

  /// Fetch popular items (shown by default)
  Future<void> fetchPopularItem() async {
    setLoading(true); // optional: use if BaseController has setLoading

    final result = await _homeRepository.fetchPopularItems();

    result.fold(
          (fail) {
        setError(fail.message);
        DPrint.log('Popular items fetch failed: ${fail.message}');
      },
          (success) {
        popularItem.value = success.data;
        DPrint.log('Popular items loaded: ${success.message}');
      },
    );

    setLoading(false);
  }

  /// Search items by keyword
  Future<void> searchItem(String text) async {
    if (text.trim().isEmpty) {
      clearSearch();
      return;
    }

    setLoading(true);

    final result = await _searchRepository.searchItem(text.trim());

    result.fold(
          (fail) {
        setError(fail.message);
        DPrint.log('Search failed: ${fail.message}');
        search.value = null; // clear previous results on error
      },
          (success) {
        search.value = success.data;
        DPrint.log('Search success: ${success.message}');
      },
    );

    setLoading(false);
  }

  /// Clear search results and go back to showing popular items
  void clearSearch() {
    search.value = null;
    update(); // Optional: if you use GetBuilder anywhere
  }

  /// Optional: Reload popular items (e.g., pull-to-refresh)
  Future<void> refreshPopularItems() async {
    await fetchPopularItem();
  }

  @override
  void onClose() {
    // Clean up if needed
    super.onClose();
  }
}