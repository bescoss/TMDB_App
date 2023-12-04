import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies_app/models/movie.dart';
import 'package:movies_app/screens/details_screen.dart';

class TabBuilder extends StatelessWidget {
  const TabBuilder({
    required this.future,
    Key? key,
  }) : super(key: key);

  final Future<List<Movie>?> future;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, left: 12.0),
      child: FutureBuilder<List<Movie>?>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final screenWidth = MediaQuery.of(context).size.width;
            final itemWidth = 180.0; // Adjust the item width as needed
            final crossAxisCount = (screenWidth / itemWidth).floor();

            return Expanded(
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 15.0,
                      mainAxisSpacing: 15.0,
                      childAspectRatio:
                          itemWidth / 300, // Maintain the aspect ratio
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        Get.to(DetailsScreen(movie: snapshot.data![index]));
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                            'https://image.tmdb.org/t/p/w500/${snapshot.data![index].posterPath}',
                            height: 300,
                            width: itemWidth,
                            fit: BoxFit.cover, loadingBuilder: (_, __, ___) {
                          if (___ == null) return __;
                          return const CircularProgressIndicator();
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
