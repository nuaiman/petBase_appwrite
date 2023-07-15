import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import '../../chats/controller/chats_controller.dart';
import '../../../models/pet_model.dart';

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
    final currentUser = ref.watch(authControllerProvider);
    // final currentLocation = ref.watch(getCurrentLocalProvider).value;
    return Scaffold(
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.only(
      //     bottom: 12,
      //     right: 5,
      //     left: 5,
      //   ),
      //   child: GestureDetector(
      //     onTap: () {
      //       ref.read(chatsControllerProvider.notifier).startConversation(
      //             context: context,
      //             ownerId: widget.petModel.uid,
      //             reqUid: currentUser.id,
      //             ownerImageUrl: widget.petModel.userImage,
      //             ownerName: widget.petModel.userName,
      //             requestingUserImageUrl: currentUser.imageUrl,
      //             requestingUserName: currentUser.name,
      //           );
      //     },
      //     child: Container(
      //       height: 45,
      //       decoration: BoxDecoration(
      //         borderRadius: BorderRadius.circular(8),
      //         color: Colors.black,
      //       ),
      //       child: const Center(
      //         child: Text(
      //           'Adopt Me',
      //           style: TextStyle(
      //             fontSize: 20,
      //             color: Colors.white,
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Center(
              child: Card(
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: DotsIndicator(
                    mainAxisSize: MainAxisSize.min,
                    dotsCount: widget.petModel.images.length,
                    position: imageCounter.toDouble(),
                    decorator: const DotsDecorator(
                      activeColor: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 50,
                    child: RawMaterialButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      elevation: 2.0,
                      fillColor: Colors.black,
                      padding: const EdgeInsets.all(10.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    height: 45,
                    width: 200,
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
                  SizedBox(
                    width: 50,
                    child: RawMaterialButton(
                      onPressed: () {},
                      elevation: 2.0,
                      fillColor: Colors.black,
                      padding: const EdgeInsets.all(10.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: LikeButton(
                        size: 25,
                        onTap: (isLiked) async {
                          ref
                              .read(petControllerProvider.notifier)
                              .likePet(widget.petModel, currentUser.id);
                          return !isLiked;
                        },
                        likeBuilder: (isLiked) {
                          return widget.petModel.likes.contains(currentUser.id)
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
                  ),
                ],
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
                    leading: SizedBox(
                      width: 50,
                      height: 50,
                      child: Card(
                        color: Colors.black,
                        child: widget.petModel.genderType == GenderType.male
                            ? const Icon(
                                Icons.male,
                                color: Colors.indigoAccent,
                                size: 20,
                              )
                            : const Icon(
                                Icons.female,
                                color: Colors.pinkAccent,
                                size: 20,
                              ),
                      ),
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
                    leading: const SizedBox(
                      width: 50,
                      height: 50,
                      child: Card(
                        color: Colors.black,
                        child: Icon(
                          Icons.location_on_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
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
                  const Text(
                    'Traits',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 5),
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
                  const SizedBox(height: 20),
                  Text(
                    'About ${widget.petModel.name}',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.petModel.about,
                    style: const TextStyle(fontSize: 18),
                  ),
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
