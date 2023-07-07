import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_base/features/auth/controller/auth_controller.dart';

import '../controller/filtered_pets_controller.dart';
import '../controller/pet_search_controller.dart';
import '../controller/pet_type_controller.dart';
import '../widgets/main_app_bar.dart';
import '../widgets/pet_tile.dart';

class PetsView extends ConsumerWidget {
  const PetsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final pets = ref.watch(initializationControllerProvider.notifier).pets;
    final petsProvider = ref.watch(filteredPetsProvider.notifier);
    final pets = petsProvider.getFilteredPets();
    final currentUser = ref.watch(getCurrentAccountProvider).value;
    ref.watch(petSearchProvider);
    ref.watch(petTypeFilterProvider);
    return DefaultTabController(
      length: 10,
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus!.unfocus();
        },
        child: Scaffold(
          // appBar: mainAppBar(context, ref),
          body: CustomScrollView(
            slivers: [
              mainAppBar(
                  context,
                  pets
                      .where(
                          (element) => element.likes.contains(currentUser!.$id))
                      .toList(),
                  ref),
              SliverToBoxAdapter(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 4.25,
                  ),
                  itemCount: pets.length,
                  itemBuilder: (context, index) =>
                      PetTile(pet: pets[index], user: currentUser!),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
