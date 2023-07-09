import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_base/features/pets/controller/pet_controller.dart';
import 'package:pet_base/features/pets/controller/pet_type_controller.dart';
import 'package:pet_base/features/pets/controller/pet_search_controller.dart';
import 'package:pet_base/models/pet_model.dart';

class FilteredPetsNotifier extends StateNotifier<List<PetModel>> {
  final PetControllerNotifier _petsInitial;
  final PetSearchNotifier _petsBySearch;
  final PetTypeNotifier _petsByType;
  FilteredPetsNotifier({
    required PetControllerNotifier petsInitial,
    required PetSearchNotifier petsBySearch,
    required PetTypeNotifier petsByType,
  })  : _petsInitial = petsInitial,
        _petsBySearch = petsBySearch,
        _petsByType = petsByType,
        super([]);

  List<PetModel> getFilteredPets() {
    List<PetModel> filteredPets = _petsInitial.pets;

    switch (_petsByType.state) {
      case PetType.all:
        filteredPets = _petsInitial.pets;
        break;
      case PetType.cat:
        filteredPets = _petsInitial.pets
            .where((pet) => pet.petType == PetType.cat)
            .toList();
        break;
      case PetType.dog:
        filteredPets = _petsInitial.pets
            .where((pet) => pet.petType == PetType.dog)
            .toList();
        break;
      case PetType.bird:
        filteredPets = _petsInitial.pets
            .where((pet) => pet.petType == PetType.bird)
            .toList();
        break;
      case PetType.rabbit:
        filteredPets = _petsInitial.pets
            .where((pet) => pet.petType == PetType.rabbit)
            .toList();
        break;
      case PetType.aquatic:
        filteredPets = _petsInitial.pets
            .where((pet) => pet.petType == PetType.aquatic)
            .toList();
        break;
      case PetType.rodent:
        filteredPets = _petsInitial.pets
            .where((pet) => pet.petType == PetType.rodent)
            .toList();
        break;
      case PetType.domestic:
        filteredPets = _petsInitial.pets
            .where((pet) => pet.petType == PetType.domestic)
            .toList();
        break;
      case PetType.reptile:
        filteredPets = _petsInitial.pets
            .where((pet) => pet.petType == PetType.reptile)
            .toList();
        break;
      case PetType.others:
        filteredPets = _petsInitial.pets
            .where((pet) => pet.petType == PetType.others)
            .toList();
        break;
    }

    if (_petsBySearch.state.isNotEmpty) {
      filteredPets = filteredPets
          .where((pet) => pet.name.toLowerCase().contains(_petsBySearch.state))
          .toList();
    } else {
      filteredPets = filteredPets;
    }

    return filteredPets;
  }

  List<PetModel> get pets => state;
}

// -----------------------------------------------------------------------------

final filteredPetsProvider =
    StateNotifierProvider<FilteredPetsNotifier, List<PetModel>>((ref) {
  final petsInitial = ref.watch(petControllerProvider.notifier);
  final petsBySearch = ref.watch(petSearchProvider.notifier);
  final petsByType = ref.watch(petTypeFilterProvider.notifier);

  return FilteredPetsNotifier(
    petsInitial: petsInitial,
    petsBySearch: petsBySearch,
    petsByType: petsByType,
  );
});
