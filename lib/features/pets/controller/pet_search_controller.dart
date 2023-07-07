import 'package:flutter_riverpod/flutter_riverpod.dart';

class PetSearchNotifier extends StateNotifier<String> {
  PetSearchNotifier() : super('');

  void getPetsBySearchTerm(String searchTerm) {
    state = searchTerm;
  }
}
// -----------------------------------------------------------------------------

final petSearchProvider =
    StateNotifierProvider<PetSearchNotifier, String>((ref) {
  return PetSearchNotifier();
});
