import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies_app/api/api.dart';
import 'package:movies_app/api/api_service.dart';
import 'package:movies_app/controllers/bottom_navigator_controller.dart';
import 'package:movies_app/controllers/movies_controller.dart';
import 'package:movies_app/controllers/search_controller.dart';
import 'package:movies_app/widgets/search_box.dart';
import 'package:movies_app/widgets/tab_builder.dart';
import 'package:movies_app/widgets/actor_tab_builder.dart';
import 'package:movies_app/widgets/top_rated_item.dart';
import 'package:movies_app/models/actors.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final MoviesController controller = Get.put(MoviesController());
  final SearchController1 searchController = Get.put(SearchController1());
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 42,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'What do you want to watch?',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            SearchBox(
              onSumbit: () {
                String search =
                    Get.find<SearchController1>().searchController.text;
                Get.find<SearchController1>().searchController.text = '';
                Get.find<SearchController1>().search(search);
                Get.find<BottomNavigatorController>().setIndex(1);
                FocusManager.instance.primaryFocus?.unfocus();
              },
            ),
            const SizedBox(
              height: 34,
            ),
            Obx(
              (() => controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      height: 300,
                      child: ListView.separated(
                        itemCount: controller.mainTopRatedMovies.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (_, __) => const SizedBox(width: 24),
                        itemBuilder: (_, index) => TopRatedItem(
                            movie: controller.mainTopRatedMovies[index],
                            index: index + 1),
                      ),
                    )),
            ),
            FutureBuilder<List<Actor>?>(
                future: ApiService.getPopularActors(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No popular actors available.');
                  } else {
                    List<Actor> popularActors = snapshot.data!;
                    return DefaultTabController(
                      length: 5,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const TabBar(
                              indicatorWeight: 5,
                              indicatorColor: Color(
                                0xFF3A3F47,
                              ),
                              tabs: [
                                Tab(text: 'Now playing'),
                                Tab(text: 'Upcoming'),
                                Tab(text: 'Top rated'),
                                Tab(text: 'Popular'),
                                Tab(text: 'Actors'),
                              ]),
                          SizedBox(
                            height: 400,
                            child: TabBarView(children: [
                              TabBuilder(
                                future: ApiService.getCustomMovies(
                                    'now_playing?api_key=${Api.apiKey}&language=en-US&page=1'),
                              ),
                              TabBuilder(
                                future: ApiService.getCustomMovies(
                                    'upcoming?api_key=${Api.apiKey}&language=en-US&page=1'),
                              ),
                              TabBuilder(
                                future: ApiService.getCustomMovies(
                                    'top_rated?api_key=${Api.apiKey}&language=en-US&page=1'),
                              ),
                              TabBuilder(
                                future: ApiService.getCustomMovies(
                                    'popular?api_key=${Api.apiKey}&language=en-US&page=1'),
                              ),
                              ActorTabBuilder(
                                  future: ApiService.getCustomActors(
                                      popularActors)),
                            ]),
                          ),
                        ],
                      ),
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}
