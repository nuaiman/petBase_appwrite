import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_base/models/pet_model.dart';

import '../../../core/utils.dart';
import '../../auth/controller/auth_controller.dart';
import '../../initialization/controller/initialization_controller.dart';
import '../controller/pet_controller.dart';

class AddPetView extends ConsumerStatefulWidget {
  const AddPetView({super.key});

  @override
  ConsumerState<AddPetView> createState() => _AddPetViewState();
}

class _AddPetViewState extends ConsumerState<AddPetView> {
// -----------------------------------------------------
  PetType petType = PetType.cat;
  String _selectedPetCategory = 'cat';
  GenderType genderType = GenderType.male;
  String _selectedGenderCategory = 'male';

  final _nameController = TextEditingController();
  final _breedNameController = TextEditingController();
  final _colorController = TextEditingController();
  // final _cityController = TextEditingController();
  final _aboutController = TextEditingController();

  List<File> _images = [];

  final _yearController = TextEditingController();
  final _monthController = TextEditingController();

  bool _isNeutered = false;
  bool _isPottyTrained = false;

  final _weightController = TextEditingController();

// -----------------------------------------------------

  bool isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _breedNameController.dispose();
    _colorController.dispose();
    _aboutController.dispose();
    _yearController.dispose();
    _monthController.dispose();
    _weightController.dispose();

    super.dispose();
  }

  void _onPickImages() async {
    _images = await pickImages();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(getCurrentAccountProvider).value;
    final localAndUser = ref.watch(initializationControllerProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: isLoading
                ? () {}
                : () {
                    Navigator.of(context).pop();
                  },
            icon: const Icon(Icons.arrow_back_ios)),
        title: const Text(
          'Uplaod Pet',
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
          ),
        ),
        actions: [
          IconButton(
            onPressed: isLoading
                ? () {}
                : () {
                    setState(() {
                      isLoading = true;
                    });
                    ref.read(petControllerProvider.notifier).sharePet(
                          context: context,
                          images: _images,
                          petModel: PetModel(
                            id: ID.unique(),
                            uid: currentUser!.$id,
                            petType: ConvertPet(_selectedPetCategory)
                                .toPetTypeEnum(),
                            genderType: ConvertGender(_selectedGenderCategory)
                                .toGenderTypeEnum(),
                            name: _nameController.text,
                            breedName: _breedNameController.text,
                            about: _aboutController.text,
                            color: _colorController.text,
                            images: [],
                            likes: [],
                            years: int.parse(_yearController.text),
                            months: int.parse(_monthController.text),
                            spayed: _isNeutered,
                            pottyTrained: _isPottyTrained,
                            weight: double.parse(_weightController.text),
                            lat: localAndUser.lat,
                            lon: localAndUser.lon,
                            postedAt: DateTime.now(),
                            city: localAndUser.city,
                            distance: 0,
                            country: localAndUser.country,
                          ),
                        );
                  },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField(
                          value: petType.type,
                          items: [
                            for (final pet in PetType.values
                                .where((element) => element != PetType.all))
                              DropdownMenuItem(
                                value: pet.name,
                                child: Row(
                                  children: [
                                    Text(pet.name),
                                  ],
                                ),
                              ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedPetCategory = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField(
                          value: genderType.type,
                          items: [
                            for (final gender in GenderType.values)
                              DropdownMenuItem(
                                value: gender.name,
                                child: Row(
                                  children: [
                                    Text(gender.name),
                                  ],
                                ),
                              ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedGenderCategory = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus!.unfocus();
                    },
                    decoration: const InputDecoration(
                      labelText: 'Pet Name',
                      border: OutlineInputBorder(),
                    ),
                    controller: _nameController,
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus!.unfocus();
                    },
                    decoration: const InputDecoration(
                      labelText: 'Breed Name',
                      border: OutlineInputBorder(),
                    ),
                    controller: _breedNameController,
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus!.unfocus();
                    },
                    decoration: const InputDecoration(
                      labelText: 'Color',
                      border: OutlineInputBorder(),
                    ),
                    controller: _colorController,
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus!.unfocus();
                          },
                          maxLength: 2,
                          decoration: const InputDecoration(
                            labelText: 'Months',
                            border: OutlineInputBorder(),
                          ),
                          controller: _monthController,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {},
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus!.unfocus();
                          },
                          maxLength: 3,
                          decoration: const InputDecoration(
                            labelText: 'Years',
                            border: OutlineInputBorder(),
                          ),
                          controller: _yearController,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {},
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus!.unfocus();
                          },
                          maxLength: 6,
                          decoration: const InputDecoration(
                            labelText: 'Weight (KG)',
                            border: OutlineInputBorder(),
                          ),
                          controller: _weightController,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus!.unfocus();
                    },
                    maxLength: 1000,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'About',
                      border: OutlineInputBorder(),
                    ),
                    controller: _aboutController,
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Spayed       ',
                              style: TextStyle(fontSize: 16),
                            ),
                            Switch(
                                inactiveThumbColor: Colors.white,
                                inactiveTrackColor: Colors.grey.shade400,
                                value: _isNeutered,
                                onChanged: (value) {
                                  setState(() {
                                    _isNeutered = value;
                                  });
                                }),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _onPickImages,
                        child: const Icon(Icons.photo_library),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Potty Trained',
                              style: TextStyle(fontSize: 16),
                            ),
                            Switch(
                                inactiveThumbColor: Colors.white,
                                inactiveTrackColor: Colors.grey.shade400,
                                value: _isPottyTrained,
                                onChanged: (value) {
                                  setState(() {
                                    _isPottyTrained = value;
                                  });
                                }),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (_images.isNotEmpty)
                    CarouselSlider(
                      items: _images
                          .map(
                            (i) => Container(
                              // width: 100,
                              height: 100,
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              child: Image.file(
                                i,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                          .toList(),
                      options: CarouselOptions(
                        viewportFraction: 0.5,
                        enableInfiniteScroll: false,
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
