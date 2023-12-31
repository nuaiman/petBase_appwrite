import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:like_button/like_button.dart';
import '../view/pet_details_view.dart';
import '../../../models/pet_model.dart';

import '../controller/pet_controller.dart';

class PetTile extends ConsumerWidget {
  const PetTile({
    super.key,
    required this.pet,
    required this.user,
  });

  final PetModel pet;
  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridTile(
      child: Card(
        elevation: 0,
        color: Colors.white,
        child: LayoutBuilder(
          builder: (context, constraints) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: constraints.maxHeight * 0.725,
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PetDetailView(petModel: pet),
                        ));
                      },
                      child: Image.network(
                        pet.images[0],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 0.0),
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                dense: true,
                minLeadingWidth: 0,
                title: Text(
                  pet.breedName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                subtitle: Text('${pet.distance.toStringAsFixed(2)} km'),
                trailing:

                    // pet.genderType == GenderType.male
                    //     ? const Icon(
                    //         Icons.male,
                    //         color: Colors.blue,
                    //       )
                    //     : const Icon(
                    //         Icons.female,
                    //         color: Colors.pink,
                    //       )

                    SizedBox(
                  height: 20,
                  width: 35,
                  child: LikeButton(
                    size: 25,
                    onTap: (isLiked) async {
                      ref
                          .read(petControllerProvider.notifier)
                          .likePet(pet, user.$id);
                      return !isLiked;
                    },
                    likeBuilder: (isLiked) {
                      return pet.likes.contains(user.$id)
                          ? const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : const Icon(Icons.favorite_border);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),

        // Column(
        //   children: [
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: ClipRRect(
        //         borderRadius: BorderRadius.circular(10),
        //         child: SizedBox(
        //           height: MediaQuery.of(context).size.width > 360
        //               ? 190
        //               : 170,
        //           width: double.infinity,
        //           child: Image.network(
        //             'https://images.unsplash.com/flagged/photo-1557427161-4701a0fa2f42?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxleHBsb3JlLWZlZWR8MXx8fGVufDB8fHx8fA%3D%3D&w=1000&q=80',
        //             fit: BoxFit.cover,
        //           ),
        //         ),
        //       ),
        //     ),
        //     const ListTile(
        //       contentPadding:
        //           EdgeInsets.symmetric(horizontal: 12, vertical: 0.0),
        //       visualDensity: VisualDensity(horizontal: 0, vertical: -4),
        //       dense: true,
        //       minLeadingWidth: 0,
        //       title: Text('Breed Name'),
        //       subtitle: Text('20.1 km away'),
        //       trailing: Icon(Icons.favorite_outline),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
