// ignore_for_file: unused_field

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_base/models/pet_model.dart';

import '../../../apis/pet_api.dart';
import '../../../apis/storage_api.dart';
import '../../../core/utils.dart';
import '../view/pets_view.dart';

class PetControllerNotifier extends StateNotifier<bool> {
  final Ref _ref;
  final PetApi _petApi;
  final StorageApi _storageApi;
  PetControllerNotifier({
    required Ref ref,
    required PetApi petApi,
    required StorageApi storageApi,
  })  : _ref = ref,
        _petApi = petApi,
        _storageApi = storageApi,
        super(false);

  void sharePet({
    required BuildContext context,
    required List<File> images,
    required PetModel petModel,
  }) async {
    state = true;
    final imageLinks = await _storageApi.uploadImages(images);
    petModel = petModel.copyWith(images: imageLinks);
    final response = await _petApi.sharePet(petModel);
    response.fold(
      (l) {
        showSnackbar(context, l.message);
        state = false;
      },
      (r) {
        state = false;
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const PetsView(),
        ));
      },
    );
  }

  // Future<List<PetModel>> getPets() async {
  //   final petList = await _petApi.getPets();
  //   return petList.map((pet) => PetModel.fromMap(pet.data)).toList();
  // }

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
      result.fold((l) => null, (r) => null);
    } catch (e) {}
  }
}
// -----------------------------------------------------------------------------

final petControllerProvider =
    StateNotifierProvider<PetControllerNotifier, bool>((ref) {
  final petApi = ref.watch(petApiProvider);
  final storageApi = ref.watch(storageApiProvider);
  return PetControllerNotifier(
      ref: ref, petApi: petApi, storageApi: storageApi);
});

// final getPetsProvider = FutureProvider((ref) async {
//   final petController = ref.watch(petControllerProvider.notifier);
//   return petController.getPets();
// });

// final filterPetsProvider = Provider.family((ref, PetType petType) async {
//   final pets = await ref.watch(petControllerProvider.notifier).getPets();
//   return pets.where((pet) => pet.petType == petType).toList();
// });
