import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_base/features/auth/controller/auth_controller.dart';
import 'package:pet_base/features/initialization/controller/initialization_controller.dart';
import 'package:pet_base/features/initialization/view/initialization_view.dart';
import 'package:pet_base/models/pet_model.dart';

import '../widgets/pet_tile.dart';

class LikeView extends ConsumerStatefulWidget {
  const LikeView({super.key, required this.userId});

  final String userId;

  @override
  ConsumerState<LikeView> createState() => _LikeViewState();
}

class _LikeViewState extends ConsumerState<LikeView> {
  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(getCurrentAccountProvider).value;
    // final pets = ref.watch(initializationControllerProvider.notifier).pets;
    // final petsProvider = ref.watch(filteredPetsProvider.notifier);
    // final pets = petsProvider.getFilteredPets();
    // ref.watch(petSearchProvider);
    // ref.watch(petTypeFilterProvider);
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const InitializationView(),
                  ),
                  (route) => false);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          title: const Text('Your Liked Pets'),
        ),
        body: FutureBuilder(
          future: ref.read(initializationControllerProvider.notifier).getPets(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            List<PetModel> pets = snapshot.data!
                .where((element) => element.likes.contains(widget.userId))
                .toList();

            return GridView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 4.25,
              ),
              itemCount: pets.length,
              itemBuilder: (context, index) {
                return PetTile(pet: pets[index], user: currentUser!);
              },
            );
          },
        ),
      ),
    );
  }
}
