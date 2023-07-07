import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:like_button/like_button.dart';
import 'package:pet_base/features/initialization/view/initialization_view.dart';
import 'package:pet_base/models/pet_model.dart';

import '../../auth/controller/auth_controller.dart';
import '../controller/pet_controller.dart';

class PetDetailView extends ConsumerStatefulWidget {
  const PetDetailView({super.key, required this.petModel});

  final PetModel petModel;

  @override
  ConsumerState<PetDetailView> createState() => _PetDetailViewState();
}

class _PetDetailViewState extends ConsumerState<PetDetailView> {
  int imageCounter = 0;

  void changeImage(int i) {
    setState(() {
      imageCounter = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(getCurrentAccountProvider).value;
    // final currentLocation = ref.watch(getCurrentLocalProvider).value;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          bottom: 12,
          right: 5,
          left: 5,
        ),
        child: Row(
          children: [
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.black,
                ),
                child: const Center(
                  child: Text(
                    'Adopt Me',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFF182747),
              ),
              child: LikeButton(
                size: 25,
                onTap: (isLiked) async {
                  ref
                      .read(petControllerProvider.notifier)
                      .likePet(widget.petModel, currentUser!.$id);
                  return !isLiked;
                },
                likeBuilder: (isLiked) {
                  return widget.petModel.likes.contains(currentUser!.$id)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                        );
                },
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 450,
                  width: MediaQuery.of(context).size.height,
                  child: Image.network(
                    widget.petModel.images[imageCounter],
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Positioned(
                  top: 40,
                  right: -10,
                  child: RawMaterialButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const InitializationView(),
                          ),
                          (route) => false);
                    },
                    elevation: 2.0,
                    fillColor: Colors.white,
                    padding: const EdgeInsets.all(10.0),
                    shape: const CircleBorder(),
                    child: const Icon(
                      Icons.close,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 70,
              child: ListView.builder(
                primary: false,
                scrollDirection: Axis.horizontal,
                itemCount: widget.petModel.images.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        changeImage(index);
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        color: Colors.amber,
                        child: Image.network(
                          widget.petModel.images[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const SizedBox(width: 10),
                PetPropertyWidget(
                    text: widget.petModel.genderType == GenderType.male
                        ? 'Male'
                        : 'Female'),
                const SizedBox(width: 5),
                PetPropertyWidget(text: '${widget.petModel.weight} Kg'),
                const SizedBox(width: 5),
                PetPropertyWidget(
                    text:
                        '${widget.petModel.years}y ${widget.petModel.months}m'),
                const SizedBox(width: 10),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const SizedBox(width: 10),
                PetPropertyWidget(text: widget.petModel.color),
                const SizedBox(width: 5),
                PetPropertyWidget(
                    text: widget.petModel.spayed ? 'Neutered' : 'Non-Neutered'),
                const SizedBox(width: 5),
                PetPropertyWidget(
                    text: widget.petModel.pottyTrained
                        ? 'Potty Trained'
                        : 'Not Potty Trained'),
                const SizedBox(width: 10),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.petModel.name,
                        style: const TextStyle(fontSize: 20),
                      ),
                      Row(
                        children: [
                          Text(
                            '${(widget.petModel.distance).toStringAsFixed(1)} km - ${widget.petModel.city}',
                          ),
                          const Icon(
                            Icons.location_on_outlined,
                            size: 30,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(widget.petModel.about),
                  const SizedBox(height: 70),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PetPropertyWidget extends StatelessWidget {
  final String text;
  const PetPropertyWidget({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.black,
        ),
        height: 30,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
