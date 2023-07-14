// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:location/location.dart';
import 'package:pet_base/apis/pet_api.dart';
import 'package:pet_base/features/auth/controller/auth_controller.dart';
import 'package:pet_base/features/pets/controller/pet_controller.dart';
import 'package:pet_base/features/pets/view/pets_view.dart';

class InitializationControllerNotifier extends StateNotifier<bool> {
  InitializationControllerNotifier({required PetApi petApi}) : super(false);

  String? _city;
  String? _country;
  double? _lat;
  double? _lon;

  String get city => _city.toString();
  String get country => _country.toString();
  double get lat => _lat!.toDouble();
  double get lon => _lon!.toDouble();

  void initializeData(BuildContext context, WidgetRef ref) async {
    await getCurrentLocation(context, ref);
    await ref.read(authControllerProvider.notifier).getCurrentAccount();
    await ref.read(petControllerProvider.notifier).getPets(ref);

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
  }
}
// -----------------------------------------------------------------------------

final initializationControllerProvider =
    StateNotifierProvider<InitializationControllerNotifier, bool>((ref) {
  final petApi = ref.watch(petApiProvider);
  return InitializationControllerNotifier(petApi: petApi);
});
