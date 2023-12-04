import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies_app/api/api_service.dart';
import 'package:movies_app/controllers/actor_controller.dart';
import 'package:movies_app/controllers/search_controller.dart';
import 'package:movies_app/widgets/actor_tab_builder.dart';
import 'package:movies_app/widgets/top_rated_actor.dart';
import 'package:movies_app/models/actors.dart';

class ActorsScreen extends StatelessWidget {
  ActorsScreen({Key? key}) : super(key: key);

  final ActorController controller = Get.put(ActorController());
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
                'What is your favourite Actor?',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(
              height: 24,
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
                        itemCount: controller.mainpopularactors.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (_, __) => const SizedBox(width: 24),
                        itemBuilder: (_, index) => TopRatedActor(
                            actor: controller.mainpopularactors[index],
                            index: index + 1),
                      ),
                    )),
            ),
            FutureBuilder<List<Actor>?>(
              future: ApiService.getPopularActors(),
              builder: (context, popularSnapshot) {
                if (popularSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (popularSnapshot.hasError) {
                  return Text('Error: ${popularSnapshot.error}');
                } else if (!popularSnapshot.hasData ||
                    popularSnapshot.data!.isEmpty) {
                  return const Text('No popular actors available.');
                } else {
                  List<Actor> popularActors = popularSnapshot.data!;

                  return FutureBuilder<List<Actor>?>(
                    future: ApiService.getTrendingActors(),
                    builder: (context, trendingSnapshot) {
                      if (trendingSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (trendingSnapshot.hasError) {
                        return Text('Error: ${trendingSnapshot.error}');
                      } else if (!trendingSnapshot.hasData ||
                          trendingSnapshot.data!.isEmpty) {
                        return const Text('No trending actors available.');
                      } else {
                        List<Actor> trendingActors = trendingSnapshot.data!;

                        return DefaultTabController(
                          length: 2,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const TabBar(
                                indicatorWeight: 4,
                                indicatorColor: Color(0xFF3A3F47),
                                tabs: [
                                  Tab(text: 'Popular'),
                                  Tab(text: 'Trending'),
                                ],
                              ),
                              SizedBox(
                                height: 400,
                                child: TabBarView(
                                  children: [
                                    ActorTabBuilder(
                                        future: ApiService.getCustomActors(
                                            popularActors)),
                                    ActorTabBuilder(
                                        future: ApiService.getCustomActors(
                                            trendingActors)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
