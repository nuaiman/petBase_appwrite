import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_base/features/auth/controller/auth_controller.dart';
import 'package:pet_base/features/initialization/view/initialization_view.dart';

import '../../../models/pet_model.dart';
import '../controller/filtered_pets_controller.dart';
import '../widgets/main_app_bar.dart';
import '../widgets/pet_tile.dart';

class PetsView extends ConsumerStatefulWidget {
  const PetsView({super.key});

  @override
  ConsumerState<PetsView> createState() => _PetsViewState();
}

class _PetsViewState extends ConsumerState<PetsView> {
  late List<PetModel> pets;

  @override
  void initState() {
    print('init Running');
    super.initState();
  }

  @override
  void didChangeDependencies() {
    pets = ref.read(filteredPetsProvider.notifier).getFilteredPets();
    print('didChangeRunning');
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // ref.watch(petControllerProvider.notifier).pets;
    // ref.watch(petControllerProvider.notifier).getPets(ref);
    // final petsProvider = ref.watch(filteredPetsProvider.notifier);
    // final pets = petsProvider.getFilteredPets();
    final currentUser = ref.watch(getCurrentAccountProvider).value;
    // ref.watch(petSearchProvider.notifier);
    // ref.watch(petTypeFilterProvider.notifier);
    return DefaultTabController(
      length: 10,
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus!.unfocus();
        },
        child: Scaffold(
          // appBar: mainAppBar(context, ref),
          body: RefreshIndicator(
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
                            element.likes.contains(currentUser!.$id))
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
                        PetTile(pet: pets[index], user: currentUser!),
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
