import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../view/chats_view.dart';
import '../../../models/conversation_model.dart';
import '../../../models/user_model.dart';

import '../../../apis/chat_api.dart';
import '../../../models/chat_model.dart';
import '../../auth/controller/auth_controller.dart';

class ChatsControllerNotifier extends StateNotifier<bool> {
  final ChatsApi _chatsApi;
  final UserModel _auth;
  ChatsControllerNotifier({required ChatsApi chatsApi, required UserModel auth})
      : _chatsApi = chatsApi,
        _auth = auth,
        super(false);

  void startConversation({
    required BuildContext context,
    required String ownerId,
    required String reqUid,
    required String ownerImageUrl,
    required String ownerName,
    required String requestingUserImageUrl,
    required String requestingUserName,
  }) async {
    await _chatsApi.startConversation(
      ConversationModel(
        postOwnerId: ownerId,
        requestingUid: reqUid,
        identifier: '${reqUid}_$ownerId',
        ownerImageUrl: ownerImageUrl,
        ownerName: ownerName,
        requestingUserImageUrl: requestingUserImageUrl,
        requestingUserName: requestingUserName,
      ),
    );

    if (context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ChatsView(),
        ),
      );
    }
  }

  void sendText({
    required BuildContext context,
    required String otherUserId,
    required String conversationId,
    required String text,
  }) async {
    await _chatsApi.sendChat(
      chat: ChatModel(
        identifier: conversationId,
        senderId: _auth.id,
        otherId: otherUserId,
        message: text,
        date: DateTime.now(),
      ),
    );
  }

  Future<List<ChatModel>> getChats({required String otherUserId}) async {
    final chatList = await _chatsApi.getChats(
        currentUserId: _auth.id, otherUserId: otherUserId);
    final list = chatList.map((chat) => ChatModel.fromMap(chat.data)).toList();
    return list;
  }

  Future<List<ConversationModel>> getConversations(String uid) async {
    final conversationList = await _chatsApi.getAllConversation(uid);
    final list = conversationList
        .map((conversation) => ConversationModel.fromMap(conversation.data))
        .toList();
    return list;
  }
}

// -----------------------------------------------------------------------------

final chatsControllerProvider =
    StateNotifierProvider<ChatsControllerNotifier, bool>((ref) {
  final chatsApi = ref.watch(chatsApiProvider);
  final auth = ref.watch(authControllerProvider);
  return ChatsControllerNotifier(chatsApi: chatsApi, auth: auth);
});

final getChatsProvider = FutureProvider.family((ref, String otherUserId) async {
  final chatController = ref.watch(chatsControllerProvider.notifier);
  return chatController.getChats(otherUserId: otherUserId);
});

final getConversationsProvider = FutureProvider.family((ref, String uid) async {
  final chatController = ref.watch(chatsControllerProvider.notifier);
  return chatController.getConversations(uid);
});

final getLatestChatProvider = StreamProvider.autoDispose((ref) {
  final chatApi = ref.watch(chatsApiProvider);
  return chatApi.getLatestChat();
});
