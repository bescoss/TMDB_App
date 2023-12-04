import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:movies_app/api/api_service.dart';
import 'package:movies_app/controllers/actor_controller.dart';
import 'package:movies_app/widgets/tab_builder.dart';

import 'package:movies_app/models/actors_id.dart';

class ActorsDetailsScreen extends StatelessWidget {
  const ActorsDetailsScreen({
    Key? key,
    required this.actor,
  }) : super(key: key);
  final Actor_id actor;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 34),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      tooltip: 'Back to home',
                      onPressed: () => Get.back(),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'Detail',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 24,
                      ),
                    ),
                    Tooltip(
                      message: 'Save this Actor to your Favourites list',
                      triggerMode: TooltipTriggerMode.tap,
                      child: IconButton(
                        onPressed: () {
                          Get.find<ActorController>().addToFavouriteList(actor);
                        },
                        icon: Obx(
                          () => Get.find<ActorController>()
                                  .isInFavouriteList(actor)
                              ? const Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                  size: 33,
                                )
                              : const Icon(
                                  Icons.star_outline,
                                  color: Colors.yellow,
                                  size: 33,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 30),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w500/${actor.profile_path_img}',
                            width: 160,
                            height: 240,
                            fit: BoxFit.cover,
                            loadingBuilder: (_, __, ___) {
                              if (___ == null) return __;
                              return const FadeShimmer(
                                width: 110,
                                height: 140,
                                highlightColor: Color(0xff22272f),
                                baseColor: Color(0xff20252d),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: SizedBox(
                        width: 300,
                        child: Text(
                          actor.name,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 200,
                      right: 30,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: const Color.fromRGBO(37, 40, 54, 0.52),
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: .6,
                      child: SizedBox(
                        width: Get.width / 1.8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/calender.svg',
                                  width: 20,
                                  height: 20,
                                  color: Colors.grey,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  actor.birthday,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const Text('|'),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/location.svg',
                                  width: 20,
                                  height: 20,
                                  color: Colors.grey,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  actor.place_of_birth,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const Text('|'),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/popularity.svg',
                                  width: 20,
                                  height: 20,
                                  color: Colors.green,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  actor.popularity.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const TabBar(
                          indicatorWeight: 2,
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorColor: Color(
                            0xFF3A3F47,
                          ),
                          tabs: [
                            Tab(text: 'Popular Movies'),
                            Tab(text: 'About'),
                          ]),
                      SizedBox(
                        height: 400,
                        child: TabBarView(children: [
                          TabBuilder(
                            future: ApiService.getBestMoviesFromActor(actor),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              actor.biography,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
