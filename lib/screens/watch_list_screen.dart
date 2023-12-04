import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies_app/api/api.dart';
import 'package:movies_app/controllers/bottom_navigator_controller.dart';
import 'package:movies_app/controllers/movies_controller.dart';
import 'package:movies_app/controllers/actor_controller.dart';
import 'package:movies_app/screens/actor_detail_screen.dart';
import 'package:movies_app/screens/details_screen.dart';
import 'package:movies_app/widgets/infos.dart';
import 'package:movies_app/widgets/actor_info.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Favourites'),
          leading: IconButton(
            tooltip: 'Back to home',
            onPressed: () => Get.find<BottomNavigatorController>().setIndex(0),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.grey,
            ),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Movies'),
              Tab(text: 'Actors'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MyFavouriteMoviesList(),
            MyFavouriteActorsList(),
          ],
        ),
      ),
    );
  }
}

class MyFavouriteMoviesList extends StatelessWidget {
  const MyFavouriteMoviesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(34.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                if (Get.find<MoviesController>().watchListMovies.isNotEmpty)
                  ...Get.find<MoviesController>().watchListMovies.map(
                        (movie) => Column(
                          children: [
                            GestureDetector(
                              onTap: () => Get.to(DetailsScreen(movie: movie)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.network(
                                      Api.imageBaseUrl + movie.posterPath,
                                      height: 180,
                                      width: 120,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => const Icon(
                                        Icons.broken_image,
                                        size: 120,
                                      ),
                                      loadingBuilder: (_, __, ___) {
                                        if (___ == null) return __;
                                        return const FadeShimmer(
                                          width: 120,
                                          height: 180,
                                          highlightColor: Color(0xff22272f),
                                          baseColor: Color(0xff20252d),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Infos(movie: movie)
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                if (Get.find<MoviesController>().watchListMovies.isEmpty)
                  const Column(
                    children: [
                      SizedBox(
                        height: 200,
                      ),
                      Text(
                        'No movies in your watch list',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ));
  }
}

class MyFavouriteActorsList extends StatelessWidget {
  const MyFavouriteActorsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(34.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                if (Get.find<ActorController>().FavouriteActors.isNotEmpty)
                  ...Get.find<ActorController>().FavouriteActors.map(
                        (actor) => Column(
                          children: [
                            Container(
                              height: 200, // Set your desired height
                              width: 600,
                              child: GestureDetector(
                                onTap: () =>
                                    Get.to(ActorsDetailsScreen(actor: actor)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.network(
                                        Api.imageBaseUrl +
                                            actor.profile_path_img,
                                        height: 180,
                                        width: 120,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            const Icon(
                                          Icons.broken_image,
                                          size: 120,
                                        ),
                                        loadingBuilder: (_, __, ___) {
                                          if (___ == null) return __;
                                          return const FadeShimmer(
                                            width: 120,
                                            height: 180,
                                            highlightColor: Color(0xff22272f),
                                            baseColor: Color(0xff20252d),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    ActorInfos(actor: actor)
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                if (Get.find<ActorController>().FavouriteActors.isEmpty)
                  const Column(
                    children: [
                      SizedBox(
                        height: 200,
                      ),
                      Text(
                        'No actors in your favourites list',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ));
  }
}
