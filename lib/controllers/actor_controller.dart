import 'package:get/get.dart';
import 'package:movies_app/api/api_service.dart';
import 'package:movies_app/models/actors_id.dart';

class ActorController extends GetxController {
  var isLoading = false.obs;
  var mainpopularactors = <Actor_id>[].obs;
  var FavouriteActors = <Actor_id>[].obs;

  @override
  void onInit() async {
    isLoading.value = true;
    await fetchPopularActors(); // Call the method to fetch popular actors
    isLoading.value = false;
    super.onInit();
  }

  Future<void> fetchPopularActors() async {
    try {
      // ignore: non_constant_identifier_names
      var TrendingActors = await ApiService.getTrendingActors();
      if (TrendingActors != null) {
        // Await the result of getCustomActors before assigning to mainpopularactors
        var customActors = await ApiService.getCustomActors(TrendingActors);
        if (customActors != null) {
          mainpopularactors.value = customActors;
        } else {
          // Handle case when there is an issue processing custom actors
          Get.snackbar('Error', 'Failed to process popular actors',
              snackPosition: SnackPosition.BOTTOM,
              animationDuration: const Duration(milliseconds: 500),
              duration: const Duration(milliseconds: 500));
        }
      } else {
        // Handle case when there is an issue fetching popular actors
        Get.snackbar('Error', 'Failed to fetch popular actors',
            snackPosition: SnackPosition.BOTTOM,
            animationDuration: const Duration(milliseconds: 500),
            duration: const Duration(milliseconds: 500));
      }
    } catch (e) {
      // Handle any errors that occur during the API call
      print('Error fetching popular actors: $e');
      Get.snackbar('Error', 'An error occurred while fetching popular actors',
          snackPosition: SnackPosition.BOTTOM,
          animationDuration: const Duration(milliseconds: 500),
          duration: const Duration(milliseconds: 500));
    }
  }

  bool isInFavouriteList(Actor_id actor) {
    return FavouriteActors.any((m) => m.id == actor.id);
  }

  void addToFavouriteList(Actor_id actor) {
    if (FavouriteActors.any((m) => m.id == actor.id)) {
      FavouriteActors.remove(actor);
      Get.snackbar('Success', 'removed from watch list',
          snackPosition: SnackPosition.BOTTOM,
          animationDuration: const Duration(milliseconds: 500),
          duration: const Duration(milliseconds: 500));
    } else {
      FavouriteActors.add(actor);
      Get.snackbar('Success', 'added to watch list',
          snackPosition: SnackPosition.BOTTOM,
          animationDuration: const Duration(milliseconds: 500),
          duration: const Duration(milliseconds: 500));
    }
  }
}
