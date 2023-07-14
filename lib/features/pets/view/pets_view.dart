import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/controller/auth_controller.dart';
import '../../initialization/view/initialization_view.dart';
import '../controller/pet_controller.dart';

import '../controller/filtered_pets_controller.dart';
import '../widgets/main_app_bar.dart';
import '../widgets/pet_tile.dart';

class PetsView extends ConsumerWidget {
  const PetsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(petControllerProvider.notifier);
    final petsProvider = ref.watch(filteredPetsProvider.notifier);
    final pets = petsProvider.getFilteredPets();
    final currentUser = ref.watch(authControllerProvider.notifier).currentUser;
    ref.watch(petControllerProvider.notifier).sortedByDate;
    return DefaultTabController(
      length: 10,
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus!.unfocus();
        },
        child: Scaffold(
          body: RefreshIndicator(
            triggerMode: RefreshIndicatorTriggerMode.onEdge,
            color: Colors.black,
            onRefresh: () {
              return Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const InitializationView(),
                  ),
                  (route) => false);
            },
            child: CustomScrollView(
              slivers: [
                mainAppBar(
                    context,
                    pets
                        .where((element) =>
                            element.likes.contains(currentUser.$id))
                        .toList(),
                    ref),
                SliverToBoxAdapter(
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 4.25,
                    ),
                    itemCount: pets.length,
                    itemBuilder: (context, index) =>
                        PetTile(pet: pets[index], user: currentUser),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
