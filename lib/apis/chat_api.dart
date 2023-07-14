import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/conversation_model.dart';

import '../constants/appwrite_constants.dart';
import '../core/providers.dart';
import '../models/chat_model.dart';

abstract class IChatsApi {
  Future<void> startConversation(ConversationModel conversation);

  // Future<List<Document>> getAllConversation(String uid);
  Future<List<Document>> getAllConversation(String uid);

  Future<String?> sendChat({required ChatModel chat});

  Future<List<Document>> getChats(
      {required String currentUserId, required String otherUserId});

  Stream<RealtimeMessage> getLatestChat();
}
// -----------------------------------------------------------------------------

class ChatsApi implements IChatsApi {
  final Databases _databases;
  final Realtime _realtime;
  ChatsApi({required Databases databases, required Realtime realtime})
      : _databases = databases,
        _realtime = realtime;

  @override
  Future<void> startConversation(ConversationModel conversation) async {
    try {
      await _databases.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.conversationsCollection,
        documentId: '${conversation.requestingUid}_${conversation.postOwnerId}',
        data: {
          'requestingUid': conversation.requestingUid,
          'postOwnerId': conversation.postOwnerId,
          'identifier':
              '${conversation.requestingUid}_${conversation.postOwnerId}',
          'ownerName': conversation.ownerName,
          'ownerImageUrl': conversation.ownerImageUrl,
          'requestingUserName': conversation.requestingUserName,
          'requestingUserImageUrl': conversation.requestingUserImageUrl,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String?> sendChat({required ChatModel chat}) async {
    Document? document;
    try {
      document = await _databases.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.chatsCollection,
        documentId: ID.unique(),
        data: chat.toMap(),
      );
      return document.$id;
      //   document = await _databases.getDocument(
      //     databaseId: AppwriteConstants.databaseId,
      //     collectionId: AppwriteConstants.chatsCollection,
      //     documentId: '${currentUserId}_$otherUserId',
      //   );
      //   return document.$id;
      // } on AppwriteException catch (e) {
      //   if (e.code == 404) {
      //     try {
      //       document = await _databases.getDocument(
      //         databaseId: AppwriteConstants.databaseId,
      //         collectionId: AppwriteConstants.chatsCollection,
      //         documentId: '${otherUserId}_$currentUserId',
      //       );
      //       return document.$id;
      //     } on AppwriteException catch (e) {
      //       if (e.code == 404) {
      //         document = await _databases.createDocument(
      //             databaseId: AppwriteConstants.databaseId,
      //             collectionId: AppwriteConstants.chatsCollection,
      //             documentId: '${currentUserId}_$otherUserId',
      //             data: {});
      //         return document.$id;
      //       }
      //     } catch (e) {
      //       rethrow;
      //     }
      //   }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Document>> getChats(
      {required String currentUserId, required String otherUserId}) async {
    final documents = await _databases.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.chatsCollection,
      // queries: [
      //   Query.equal('id', '${currentUserId}_$otherUserId'),
      //   Query.equal('id', '${otherUserId}_$currentUserId'),
      // ],
    );
    return documents.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestChat() {
    return _realtime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.chatsCollection}.documents'
    ]).stream;
  }

  @override
  Future<List<Document>> getAllConversation(String uid) async {
    DocumentList documents1 = await _databases.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.conversationsCollection,
      queries: [
        // Query.equal('postOwnerId', uid),
        Query.equal('requestingUid', uid),
      ],
    );

    DocumentList documents2 = await _databases.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.conversationsCollection,
      queries: [
        Query.equal('postOwnerId', uid),
        // Query.equal('requestingUid', uid),
      ],
    );

    if (documents1.documents.isEmpty) {
      return documents2.documents;
    }

    return documents1.documents;
  }
}
// -----------------------------------------------------------------------------

final chatsApiProvider = Provider((ref) {
  final databases = ref.watch(appwriteDatabaseProvider);
  final realtime = ref.watch(appwriteRealtimeProvider);
  return ChatsApi(databases: databases, realtime: realtime);
});
