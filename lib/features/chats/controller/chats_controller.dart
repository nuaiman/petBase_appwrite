import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_base/apis/auth_api.dart';
import 'package:pet_base/models/user_model.dart';

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

  void sendText(
      {required BuildContext context,
      required String otherUserId,
      required String text}) async {
    await _chatsApi.sendChat(
      currentUserId: _auth.id,
      otherUserId: otherUserId,
      chat: ChatModel(
        identifier: '${_auth.id}_$otherUserId',
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

final getLatestChatProvider = StreamProvider.autoDispose((ref) {
  final chatApi = ref.watch(chatsApiProvider);
  return chatApi.getLatestChat();
});
