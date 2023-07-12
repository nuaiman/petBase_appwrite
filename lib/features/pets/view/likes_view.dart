import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_base/features/pets/controller/pet_controller.dart';
import 'package:pet_base/models/pet_model.dart';

import '../../auth/controller/auth_controller.dart';
import '../widgets/pet_tile.dart';

class LikeView extends ConsumerWidget {
  const LikeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(getCurrentAccountProvider).value;
    final pets = ref.watch(petControllerProvider);
    List<PetModel> likedPets = pets
        .where(
          (element) => element.likes.contains(currentUser!.$id),
        )
        .toList();
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Liked Pets'),
        ),
        body: GridView.builder(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 4.25,
          ),
          itemCount: likedPets.length,
          itemBuilder: (context, index) {
            return PetTile(pet: likedPets[index], user: currentUser!);
          },
        ),
      ),
    );
  }
}
