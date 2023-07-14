import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../core/providers.dart';
import '../models/pet_model.dart';

import '../constants/appwrite_constants.dart';
import '../core/failure.dart';
import '../core/type_defs.dart';

abstract class IPetApi {
  FutureEither<Document> sharePet(PetModel petModel);
  Future<List<Document>> getPets();
  Stream<RealtimeMessage> getLatestPet();
  FutureEither<Document> likePet(PetModel petModel);
}
// -----------------------------------------------------------------------------

class PetApi implements IPetApi {
  final Databases _db;
  final Realtime _realtime;
  PetApi({required Databases databases, required Realtime realtime})
      : _db = databases,
        _realtime = realtime;

  @override
  FutureEither<Document> sharePet(PetModel petModel) async {
    try {
      final document = await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.petsCollection,
        documentId: ID.unique(),
        data: petModel.toMap(),
      );
      return right(document);
    } on AppwriteException catch (e, stackTrace) {
      return left(
          Failure(e.message ?? 'Some unexpected error occured!', stackTrace));
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }

  @override
  Future<List<Document>> getPets() async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.petsCollection,
      queries: [
        Query.orderDesc('postedAt'),
      ],
    );
    return documents.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestPet() {
    return _realtime.subscribe(
      [
        'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.petsCollection}.documents'
      ],
    ).stream;
  }

  @override
  FutureEither<Document> likePet(PetModel petModel) async {
    try {
      final document = await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.petsCollection,
        documentId: petModel.id,
        data: {
          'likes': petModel.likes,
        },
      );
      return right(document);
    } on AppwriteException catch (e, stackTrace) {
      return left(
          Failure(e.message ?? 'Some unexpected error occured!', stackTrace));
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }
}
// -----------------------------------------------------------------------------

final petApiProvider = Provider((ref) {
  final databases = ref.watch(appwriteDatabaseProvider);
  final realtime = ref.watch(appwriteRealtimeProvider);
  return PetApi(databases: databases, realtime: realtime);
});

final getLatestPetProvider = StreamProvider.autoDispose((ref) {
  final petApi = ref.watch(petApiProvider);
  return petApi.getLatestPet();
});
