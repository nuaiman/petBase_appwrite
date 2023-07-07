// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geo;
import '../../../core/utils.dart';

import '../controller/auth_controller.dart';

class UpdateUserProfileView extends ConsumerStatefulWidget {
  const UpdateUserProfileView({super.key, required this.userId});

  final String userId;

  @override
  ConsumerState<UpdateUserProfileView> createState() =>
      _UpdateUserProfileViewState();
}

class _UpdateUserProfileViewState extends ConsumerState<UpdateUserProfileView> {
  // File? _image;
  final bool _isGettingLocation = false;

  String? city;
  String? country;
  double? lat = 0;
  double? lon = 0;

  final _nameController = TextEditingController();

  Future<void> getCurrentLocation() async {
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

    setState(() {
      city = placeList[0].locality.toString();
      country = placeList[0].country.toString();
      lat = locationData.latitude!;
      lon = locationData.longitude!;
    });
  }

// {
//   // Future<void> getCurrentLocation() async {
//   //   bool serviceEnabled;
//   //   PermissionStatus permissionGranted;
//   //   LocationData locationData;
//   //   Location location = Location();
//   //   serviceEnabled = await location.serviceEnabled();
//   //   if (!serviceEnabled) {
//   //     serviceEnabled = await location.requestService();
//   //     if (!serviceEnabled) {
//   //       return;
//   //     }
//   //   }
//   //   permissionGranted = await location.hasPermission();
//   //   if (permissionGranted == PermissionStatus.denied) {
//   //     permissionGranted = await location.requestPermission();
//   //     if (permissionGranted != PermissionStatus.granted) {
//   //       return;
//   //     }
//   //   }
//   //   setState(() {
//   //     _isGettingLocation = true;
//   //   });
//   //   locationData = await location.getLocation();
//   //   final latitude = locationData.latitude;
//   //   final longitude = locationData.longitude;
//   //   print(latitude);
//   //   print(longitude);
//   //   if (latitude == null || longitude == null) {
//   //     setState(() {
//   //       _isGettingLocation = false;
//   //     });
//   //     return;
//   //   }
//   //   final placeList = _getLocationAddress(latitude, longitude);
//   // }
//   // Future<List<geo.Placemark>> _getLocationAddress(
//   //     double latitude, double longitude) async {
//   //   List<geo.Placemark> placeList =
//   //       await geo.placemarkFromCoordinates(latitude, longitude);
//   //   print(placeList);
//   //   return placeList;
//   // }
//   // void _savePlace(double latitude, double longitude) async {
//   //   final addressData = await _getLocationAddress(latitude, longitude);
//   //   if (addressData.isEmpty) {
//   //     return;
//   //   }
//   //   print(addressData);
//   //   // final String? street = addressData[0].street;
//   //   // final String? postalCode = addressData[0].postalCode;
//   //   // final String? locality = addressData[0].locality;
//   //   // final String? country = addressData[0].country;
//   //   // final String address = '$street, $postalCode, $locality, $country';
//   //   // setState(() {
//   //   //   _pickedLocation = PlaceLocation(
//   //   //     latitude: latitude,
//   //   //     longitude: longitude,
//   //   //     address: address,
//   //   //   );
//   //   //   _isGettingLocation = false;
//   //   // });
//   //   // widget.onLocationPicked(_pickedLocation!);
//   // }
//   // Future<dynamic> getCurrentLocation() async {
//   //   var result = await LocationPlus.getCurrentLocation()
//   //       .timeout(const Duration(seconds: 20));
//   //   setState(() {
//   //     area = result['locality'];
//   //     city = result['administrativeArea'];
//   //     country = result['country'];
//   //     lat = double.parse(result['latitude']);
//   //     lon = double.parse(result['longitude']);
//   //   });
//   // }
// }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submitData() async {
    if (_nameController.text.isEmpty) {
      showSnackbar(context, 'Please enter your name');
      return;
    }
    await getCurrentLocation();

    if (city!.isEmpty || country!.isEmpty) {
      showSnackbar(context, 'Please click to get your location again');
      return;
    }

    ref.read(authControllerProvider.notifier).createOrUpdateUser(
          ref,
          context,
          widget.userId,
          _nameController.text,
          city.toString(),
          country.toString(),
          lat!.toDouble(),
          lon!.toDouble(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/background.png'),
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Padding(
                //   padding:
                //       const EdgeInsets.symmetric(vertical: 24, horizontal: 40),
                //   child: Center(
                //     child: InkWell(
                //       borderRadius: BorderRadius.circular(50),
                //       enableFeedback: true,
                //       onTap: () async {
                //         final pickedImage = await pickImage();
                //         if (pickedImage != null) {
                //           setState(() {
                //             _image = pickedImage;
                //           });
                //         }
                //       },
                //       child: Stack(
                //         children: [
                //           CircleAvatar(
                //             radius: 56,
                //             backgroundColor: Colors.deepPurpleAccent,
                //             child: CircleAvatar(
                //               radius: 52,
                //               backgroundImage: _image == null
                //                   ? const AssetImage('assets/images/logo.png')
                //                       as ImageProvider<Object>
                //                   : FileImage(
                //                       File(_image!.path),
                //                     ),
                //             ),
                //           ),
                //           const Positioned(
                //             bottom: 2,
                //             right: 0,
                //             child: CircleAvatar(
                //               backgroundColor: Colors.white,
                //               radius: 15,
                //               child: Icon(
                //                 Icons.add,
                //                 size: 24,
                //                 color: Colors.black,
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: TextFormField(
                    autocorrect: true,
                    enableSuggestions: true,
                    controller: _nameController,
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (value) {},
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Name',
                      alignLabelWithHint: true,
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    minWidth: double.infinity,
                    height: 60,
                    color: Colors.white,
                    textColor: Colors.white,
                    onPressed: _isGettingLocation
                        ? () {}
                        : isLoading
                            ? () {}
                            : _submitData,
                    child: _isGettingLocation
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Submit',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
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
