import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:movies_app/api/api_service.dart';
import 'package:movies_app/models/movie.dart';
import 'package:movies_app/models/actors_id.dart';

class SearchController1 extends GetxController {
  TextEditingController searchController = TextEditingController();
  var searchText = ''.obs;
  var foundedMovies = <Movie>[].obs;
  var foundedActors = <Actor_id>[].obs;

  var isLoading = false.obs;
  void setSearchText(text) => searchText.value = text;
  void search(String query) async {
    isLoading.value = true;
    foundedMovies.value = (await ApiService.getSearchedMovies(query)) ?? [];
    foundedActors.value = (await ApiService.getSearchedActors(query)) ?? [];

    isLoading.value = false;
  }
}
