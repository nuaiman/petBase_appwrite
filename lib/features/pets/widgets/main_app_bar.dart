import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_base/features/pets/controller/pet_search_controller.dart';
import 'package:pet_base/models/pet_model.dart';

import '../../auth/controller/auth_controller.dart';
import '../controller/pet_type_controller.dart';
import '../view/add_pet_view.dart';

// SliverAppBar mainAppBar(BuildContext context, WidgetRef ref) {
//   return SliverAppBar(
//     snap: true,
//     floating: true,
//     title: SizedBox(
//       height: 50,
//       child: SearchBar(
//         leading: const Icon(Icons.search),
//         elevation: const MaterialStatePropertyAll(0.5),
//         padding: const MaterialStatePropertyAll(
//             EdgeInsets.symmetric(horizontal: 20)),
//         shape: MaterialStatePropertyAll(
//           RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ),
//       ),
//     ),
//     actions: [
//       Card(
//         color: const Color.fromARGB(255, 188, 201, 228),
//         elevation: 2,
//         child: SizedBox(
//           height: 50,
//           width: 45,
//           child: IconButton(
//             onPressed: () {
//               showDialog(
//                 context: context,
//                 builder: (context) => const AlertDialog(),
//               );
//             },
//             icon: const Icon(
//               Icons.tune,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),
//       const SizedBox(width: 10),
//       // Card(
//       //   color: const Color(0xFFE3ECFF),
//       //   elevation: 0,
//       //   child: SizedBox(
//       //     height: 50,
//       //     width: 45,
//       //     child: IconButton(
//       //       onPressed: () {},
//       //       icon: const Icon(Icons.add),
//       //     ),
//       //   ),
//       // ),
//     ],
//     bottom: const TabBar(
//       isScrollable: true,
//       tabs: [
//         Tab(
//           text: 'All',
//         ),
//         Tab(
//           text: 'Cats',
//         ),
//         Tab(
//           text: 'Dogs',
//         ),
//         Tab(
//           text: 'Rabbits',
//         ),
//         Tab(
//           text: 'Aquatic',
//         ),
//         Tab(
//           text: 'Rodents',
//         ),
//         Tab(
//           text: 'Domestic',
//         ),
//         Tab(
//           text: 'Others',
//         ),
//       ],
//     ),
//   );
// }

SliverAppBar mainAppBar(BuildContext context, WidgetRef ref) {
  final user = ref.watch(getCurrentAccountProvider).value;
  return SliverAppBar(
    floating: true,
    snap: true,
    leading: Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        backgroundImage: NetworkImage(user!.prefs.data['imageUrl']),
      ),
    ),
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Location',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        Text(
          user.prefs.data['country'],
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16,
          ),
        ),
      ],
    ),
    actions: [
      IconButton(
        onPressed: () {},
        icon: const Icon(
          Icons.favorite_outline,
        ),
      ),
      const SizedBox(width: 10),
      IconButton(
        onPressed: () {},
        icon: const Icon(Icons.chat_outlined),
      ),
      const SizedBox(width: 10),
    ],
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight * 1.7),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const SizedBox(width: 15),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: SearchBar(
                    onChanged: (value) {
                      ref
                          .read(petSearchProvider.notifier)
                          .getPetsBySearchTerm(value);
                    },
                    leading: const Icon(Icons.search),
                    elevation: const MaterialStatePropertyAll(0.5),
                    padding: const MaterialStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 20)),
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Card(
                color: const Color(0xFFE3ECFF),
                elevation: 0,
                child: SizedBox(
                  height: 50,
                  width: 45,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AddPetView(),
                      ));
                    },
                    icon: const Icon(Icons.add),
                  ),
                ),
              ),
              // Card(
              //   color: const Color(0xFFE3ECFF),
              //   elevation: 0,
              //   child: SizedBox(
              //     height: 50,
              //     width: 45,
              //     child: IconButton(
              //       onPressed: () {
              //         showDialog(
              //           context: context,
              //           builder: (context) => const AlertDialog(),
              //         );
              //       },
              //       icon: const Icon(Icons.tune),
              //     ),
              //   ),
              // ),
              const SizedBox(width: 10),
            ],
          ),
          TabBar(
            isScrollable: true,
            tabs: [
              TabBuilder(
                text: 'All',
                onTap: () {
                  ref
                      .read(petTypeFilterProvider.notifier)
                      .getPetsByType(PetType.all);
                },
              ),
              TabBuilder(
                text: 'Cats',
                onTap: () {
                  ref
                      .read(petTypeFilterProvider.notifier)
                      .getPetsByType(PetType.cat);
                },
              ),
              TabBuilder(
                text: 'Dogs',
                onTap: () {
                  ref
                      .read(petTypeFilterProvider.notifier)
                      .getPetsByType(PetType.dog);
                },
              ),
              TabBuilder(
                text: 'Birds',
                onTap: () {
                  ref
                      .read(petTypeFilterProvider.notifier)
                      .getPetsByType(PetType.bird);
                },
              ),
              TabBuilder(
                text: 'Rabbits',
                onTap: () {
                  ref
                      .read(petTypeFilterProvider.notifier)
                      .getPetsByType(PetType.rabbit);
                },
              ),
              TabBuilder(
                text: 'Aquatic',
                onTap: () {
                  ref
                      .read(petTypeFilterProvider.notifier)
                      .getPetsByType(PetType.aquatic);
                },
              ),
              TabBuilder(
                text: 'Rodents',
                onTap: () {
                  ref
                      .read(petTypeFilterProvider.notifier)
                      .getPetsByType(PetType.rodent);
                },
              ),
              TabBuilder(
                text: 'Domestic',
                onTap: () {
                  ref
                      .read(petTypeFilterProvider.notifier)
                      .getPetsByType(PetType.domestic);
                },
              ),
              TabBuilder(
                text: 'Reptiles',
                onTap: () {
                  ref
                      .read(petTypeFilterProvider.notifier)
                      .getPetsByType(PetType.reptile);
                },
              ),
              TabBuilder(
                text: 'Others',
                onTap: () {
                  ref
                      .read(petTypeFilterProvider.notifier)
                      .getPetsByType(PetType.others);
                },
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class TabBuilder extends StatelessWidget {
  const TabBuilder({
    super.key,
    required this.text,
    required this.onTap,
  });

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Tab(
        text: text,
      ),
    );
  }
}
