import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:pet_base/models/pet_model.dart';

import '../../auth/controller/auth_controller.dart';
import '../controller/pet_controller.dart';

class PetDetailView extends ConsumerStatefulWidget {
  const PetDetailView({super.key, required this.petModel});

  final PetModel petModel;

  @override
  ConsumerState<PetDetailView> createState() => _PetDetailViewState();
}

class _PetDetailViewState extends ConsumerState<PetDetailView> {
  int imageCounter = 0;

  void changeImage(int i) {
    setState(() {
      imageCounter = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(getCurrentAccountProvider).value;
    // final currentLocation = ref.watch(getCurrentLocalProvider).value;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          bottom: 12,
          right: 5,
          left: 5,
        ),
        child: Row(
          children: [
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.black,
                ),
                child: const Center(
                  child: Text(
                    'Adopt Me',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFF182747),
              ),
              child: LikeButton(
                size: 25,
                onTap: (isLiked) async {
                  ref
                      .read(petControllerProvider.notifier)
                      .likePet(widget.petModel, currentUser!.$id);
                  return !isLiked;
                },
                likeBuilder: (isLiked) {
                  return widget.petModel.likes.contains(currentUser!.$id)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                        );
                },
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: 450,
                    viewportFraction: 1,
                    onPageChanged: (index, reason) {
                      setState(() {
                        imageCounter = index;
                      });
                    },
                  ),
                  items: widget.petModel.images.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: const BoxDecoration(color: Colors.white),
                          child: Image.network(
                            i,
                            fit: BoxFit.fitHeight,
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                Positioned(
                  top: 40,
                  right: -10,
                  child: RawMaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    elevation: 2.0,
                    fillColor: Colors.white,
                    padding: const EdgeInsets.all(10.0),
                    shape: const CircleBorder(),
                    child: const Icon(
                      Icons.close,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Center(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: DotsIndicator(
                    dotsCount: widget.petModel.images.length,
                    position: imageCounter.toDouble(),
                    decorator: const DotsDecorator(
                      activeColor: Colors.indigoAccent,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    minVerticalPadding: 0, // else 2px still present
                    dense: true, // else 2px still present
                    visualDensity:
                        VisualDensity.compact, // Else theme will be use
                    contentPadding: const EdgeInsets.all(0),
                    leading: widget.petModel.genderType == GenderType.male
                        ? const Icon(
                            Icons.male,
                            color: Colors.indigoAccent,
                            size: 30,
                          )
                        : const Icon(
                            Icons.female,
                            color: Colors.pinkAccent,
                            size: 30,
                          ),
                    title: Text(
                      widget.petModel.name,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      widget.petModel.breedName,
                      style: const TextStyle(
                        // fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: Text(
                      DateFormat.yMMMd().format(widget.petModel.postedAt),
                      style: const TextStyle(
                        // fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ListTile(
                    minVerticalPadding: 0, // else 2px still present
                    dense: true, // else 2px still present
                    visualDensity:
                        VisualDensity.compact, // Else theme will be use
                    contentPadding: const EdgeInsets.all(0),
                    leading: const Icon(
                      Icons.location_on_rounded,
                      color: Colors.indigoAccent,
                      size: 30,
                    ),
                    title: Text(
                      widget.petModel.city,
                      style: const TextStyle(),
                    ),
                    trailing: Text(
                      '${(widget.petModel.distance).toStringAsFixed(1)} Km',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'About ${widget.petModel.name}',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            // Chip(
                            //     avatar: widget.petModel.genderType ==
                            //             GenderType.male
                            //         ? const Icon(
                            //             Icons.male,
                            //             color: Colors.indigoAccent,
                            //           )
                            //         : const Icon(
                            //             Icons.female,
                            //             color: Colors.pinkAccent,
                            //           ),
                            //     label: Text(widget.petModel.genderType ==
                            //             GenderType.male
                            //         ? 'Male'
                            //         : 'Female')),
                            const SizedBox(width: 5),
                            Chip(
                                avatar: const Icon(
                                  Icons.scale,
                                  color: Colors.black45,
                                ),
                                label: Text('${widget.petModel.weight} Kg')),
                            const SizedBox(width: 5),
                            Chip(
                                avatar: const Icon(
                                  Icons.hourglass_bottom,
                                  color: Colors.black45,
                                ),
                                label: Text(
                                    '${widget.petModel.years}y ${widget.petModel.months}m')),
                            const SizedBox(width: 5),
                            Chip(
                                avatar: const Icon(
                                  Icons.palette,
                                  color: Colors.black45,
                                ),
                                label: Text(widget.petModel.color)),
                            const SizedBox(width: 5),
                            Chip(
                                avatar: const Icon(
                                  Icons.cut,
                                  color: Colors.black45,
                                ),
                                label: Text(widget.petModel.spayed
                                    ? 'Neutered'
                                    : 'Non-Neutered')),

                            const SizedBox(width: 5),
                            Chip(
                                avatar: const Icon(
                                  Icons.sports,
                                  color: Colors.black45,
                                ),
                                label: Text(widget.petModel.pottyTrained
                                    ? 'Potty Trained'
                                    : 'Not Potty Trained')),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(widget.petModel.about),
                  const SizedBox(height: 70),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
