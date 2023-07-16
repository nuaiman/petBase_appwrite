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
    List uniqueId = [ownerId, reqUid];
    uniqueId.sort();
    final key = '${uniqueId[0]}_${uniqueId[1]}';
    await _chatsApi.startConversation(
      ConversationModel(
        postOwnerId: ownerId,
        requestingUid: reqUid,
        identifier: key,
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
    required String conversationId,
    required String text,
  }) async {
    await _chatsApi.sendChat(
      chat: ChatModel(
        identifier: conversationId,
        senderId: _auth.id,
        message: text,
        date: DateTime.now(),
      ),
    );
  }

  Future<List<ChatModel>> getChats({required String conversationId}) async {
    final chatList = await _chatsApi.getChats(identifier: conversationId);
    final list = chatList.map((chat) => ChatModel.fromMap(chat.data)).toList();
    return list;
  }

  Future<List<ConversationModel>> getConversations(String uid) async {
    final conversationList1 = await _chatsApi.getAllConversation(1, uid);
    final conversationList2 = await _chatsApi.getAllConversation(2, uid);
    final list1 = conversationList1
        .map((conversation) => ConversationModel.fromMap(conversation.data))
        .toList();
    final list2 = conversationList2
        .map((conversation) => ConversationModel.fromMap(conversation.data))
        .toList();
    final list = list1 + list2;
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

final getChatsProvider = FutureProvider.family((ref, String convoId) async {
  final chatController = ref.watch(chatsControllerProvider.notifier);
  return chatController.getChats(conversationId: convoId);
});

final getConversationsProvider = FutureProvider.family((ref, String uid) async {
  final chatController = ref.watch(chatsControllerProvider.notifier);
  return chatController.getConversations(uid);
});

final getLatestChatProvider = StreamProvider.autoDispose((ref) {
  final chatApi = ref.watch(chatsApiProvider);
  return chatApi.getLatestChat();
});
