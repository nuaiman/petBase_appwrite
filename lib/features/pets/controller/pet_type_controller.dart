import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/pet_model.dart';

class PetTypeNotifier extends StateNotifier<PetType> {
  PetTypeNotifier() : super(PetType.all);

  void getPetsByType(PetType type) {
    state = type;
  }
}
//------------------------------------------------------------------------------

final petTypeFilterProvider =
    StateNotifierProvider<PetTypeNotifier, PetType>((ref) {
  return PetTypeNotifier();
});
