import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_base/features/initialization/controller/initialization_controller.dart';
import 'package:pet_base/models/pet_model.dart';

import '../../../apis/pet_api.dart';
import '../../../apis/storage_api.dart';
import '../../../core/utils.dart';
import '../view/pets_view.dart';

class PetControllerNotifier extends StateNotifier<List<PetModel>> {
  // final Ref _ref;
  final PetApi _petApi;
  final StorageApi _storageApi;
  PetControllerNotifier({
    // required Ref ref,
    required PetApi petApi,
    required StorageApi storageApi,
  })  :
        // _ref = ref,
        _petApi = petApi,
        _storageApi = storageApi,
        super([]);

  bool isloading = false;

  bool _sortedByDate = false;
  bool get sortedByDate => _sortedByDate;

  void reSortPets() {
    _sortedByDate = !_sortedByDate;
    state = state
      ..sort(
        (b, a) => _sortedByDate
            ? a.postedAt.compareTo(b.postedAt)
            : b.distance.compareTo(a.distance),
      );
    final newList = [...state];
    state = newList;
  }

  void setPets(List<PetModel> pets) {
    state = pets;
  }

  void sharePet({
    required BuildContext context,
    required List<File> images,
    required PetModel petModel,
  }) async {
    isloading = true;
    final imageLinks = await _storageApi.uploadImages(images);
    petModel = petModel.copyWith(images: imageLinks);
    final response =
        await _petApi.sharePet(petModel).timeout(const Duration(seconds: 10));
    response.fold(
      (l) {
        showSnackbar(context, l.message);
        isloading = false;
      },
      (r) {
        isloading = false;
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const PetsView(),
        ));
        showSnackbar(context, 'Please pull to refresh');
      },
    );
  }

  Future<List<PetModel>> getPets(WidgetRef ref) async {
    double calculateDistance(lat1, lon1, lat2, lon2) {
      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 -
          c((lat2 - lat1) * p) / 2 +
          c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
      return 12742 * asin(sqrt(a));
    }

    final lat = ref.read(initializationControllerProvider.notifier).lat;
    final lon = ref.read(initializationControllerProvider.notifier).lon;

    final petList = await _petApi.getPets();

    state = petList
        .map((pet) => PetModel.fromMap(pet.data).copyWith(
            distance:
                calculateDistance(lat, lon, pet.data['lat'], pet.data['lon'])))
        .toList();
    return state;
  }

  void likePet(PetModel petModel, String userId) async {
    List<String> likes = petModel.likes;

    if (likes.contains(userId)) {
      likes.remove(userId);
    } else {
      likes.add(userId);
    }

    petModel = petModel.copyWith(likes: likes);

    try {
      final result = await _petApi.likePet(petModel);
      result.fold((l) => null, (r) {
        final singlePet = PetModel.fromMap(r.data);
        updateSinglePetLikes(singlePet.id, singlePet.likes);
      });
    } catch (e) {
      rethrow;
    }
  }

  void updateSinglePetLikes(String petId, List<String> likes) {
    List<PetModel> extractedPets = [...state];
    PetModel editablePet =
        extractedPets.firstWhere((element) => element.id == petId);
    int editablePetIndex = extractedPets.indexOf(editablePet);
    extractedPets.remove(editablePet);
    extractedPets.insert(editablePetIndex, editablePet.copyWith(likes: likes));
    state = extractedPets;
  }
}
// -----------------------------------------------------------------------------

final petControllerProvider =
    StateNotifierProvider<PetControllerNotifier, List<PetModel>>((ref) {
  final petApi = ref.watch(petApiProvider);
  final storageApi = ref.watch(storageApiProvider);
  return PetControllerNotifier(
      // ref: ref,
      petApi: petApi,
      storageApi: storageApi);
});

// final getPetsProvider = FutureProvider((ref) async {
//   final petController = ref.watch(petControllerProvider.notifier);
//   return petController.getPets();
// });

// final filterPetsProvider = Provider.family((ref, PetType petType) async {
//   final pets = await ref.watch(petControllerProvider.notifier).getPets();
//   return pets.where((pet) => pet.petType == petType).toList();
// });
