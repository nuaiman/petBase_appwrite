// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:pet_base/apis/pet_api.dart';
import 'package:pet_base/features/auth/controller/auth_controller.dart';
import 'package:pet_base/features/pets/controller/pet_controller.dart';
import 'package:pet_base/features/pets/view/pets_view.dart';

import '../../../models/pet_model.dart';
import '../../../models/user_model.dart';

class InitializationControllerNotifier extends StateNotifier<bool> {
  final PetApi _petApi;
  InitializationControllerNotifier({required PetApi petApi})
      : _petApi = petApi,
        super(false);

  String? _city;
  String? _country;
  double? _lat;
  double? _lon;

  late UserModel _currentUser;
  late List<PetModel> _pets;

  String get city => _city.toString();
  String get country => _country.toString();
  double get lat => _lat!.toDouble();
  double get lon => _lon!.toDouble();
  UserModel get currentUser => _currentUser;
  List<PetModel> get pets => _pets;

  void initializeData(BuildContext context, WidgetRef ref) async {
    await getCurrentLocation(context, ref);
    await initializeCurrentUser(ref);
    final pets = await getPets();
    ref.read(petControllerProvider.notifier).setPets(pets);

    // print(_pets);

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const PetsView()),
        (route) => false);
  }

  Future<void> getCurrentLocation(BuildContext context, WidgetRef ref) async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    Location location = Location();

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();

    List<geo.Placemark> placeList = await geo.placemarkFromCoordinates(
        locationData.latitude!, locationData.longitude!);

    _city = placeList[0].locality.toString();
    _country = placeList[0].country.toString();
    _lat = locationData.latitude!;
    _lon = locationData.longitude!;

    print(_city);
    print(_country);
    print(_lat);
    print(_lon);
  }

  Future<UserModel> initializeCurrentUser(WidgetRef ref) async {
    final user = ref.read(getCurrentAccountProvider).value;
    final currentUser = UserModel(
      id: user!.$id,
      name: user.name,
      phoneNumber: user.phone,
      city: city,
      country: country,
      imageUrl: user.prefs.data['imageUrl'],
      lat: lat,
      lon: lon,
      pets: user.prefs.data['pets'] ?? [],
      likes: user.prefs.data['likes'] ?? [],
      conversations: user.prefs.data['conversations'] ?? [],
    );
    print(currentUser.toString());
    return currentUser;
  }

  Future<List<PetModel>> getPets() async {
    double calculateDistance(lat1, lon1, lat2, lon2) {
      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 -
          c((lat2 - lat1) * p) / 2 +
          c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
      return 12742 * asin(sqrt(a));
    }

    final petList = await _petApi.getPets();
    _pets = petList
        .map((pet) => PetModel.fromMap(pet.data).copyWith(
            distance:
                calculateDistance(lat, lon, pet.data['lat'], pet.data['lon'])))
        .toList();

    return _pets;
  }
}
// -----------------------------------------------------------------------------

final initializationControllerProvider =
    StateNotifierProvider<InitializationControllerNotifier, bool>((ref) {
  final petApi = ref.watch(petApiProvider);
  return InitializationControllerNotifier(petApi: petApi);
});
