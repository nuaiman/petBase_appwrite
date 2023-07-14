import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/controller/auth_controller.dart';
import '../../../models/conversation_model.dart';

import '../../../common/error_page.dart';
import '../../../common/loading_page.dart';
import '../../../constants/appwrite_constants.dart';
import '../../../models/chat_model.dart';
import '../../../models/user_model.dart';
import '../controller/chats_controller.dart';

class TextList extends ConsumerWidget {
  const TextList({super.key, required this.conversation});

  final ConversationModel conversation;

  // if (realTime.events.contains(
  //             'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.chatsCollection}.documents.*.create')) {
  //           ref.read(getChatsProvider(otherUser.id));
  //         }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserModel currentUser = ref.watch(authControllerProvider);
    String otherUserId = currentUser.id == conversation.postOwnerId
        ? conversation.requestingUid
        : conversation.postOwnerId;
    return ref.watch(getChatsProvider(otherUserId)).when(
          data: (data) {
            ref.watch(getLatestChatProvider).when(
                  data: (realTime) {
                    if (realTime.events.contains(
                            'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.chatsCollection}.documents.*.create') &&
                        ((realTime.payload['senderId'] == currentUser.id &&
                                realTime.payload['otherId'] == otherUserId) ||
                            (realTime.payload['otherId'] == currentUser.id &&
                                realTime.payload['senderId'] == otherUserId))) {
                      // ref.read(getChatsProvider(otherUser.id));

                      data.add(ChatModel.fromMap(realTime.payload));
                    }
                  },
                  error: (error, stackTrace) =>
                      ErrorText(error: error.toString()),
                  loading: () => const Loader(),
                );
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) => BubbleNormal(
                text: data[index].message,
                textStyle: TextStyle(
                  color: data[index].senderId == currentUser.id
                      ? Colors.black
                      : Colors.white,
                  fontSize: 16,
                ),
                isSender: data[index].senderId == currentUser.id ? true : false,
                color: data[index].senderId == currentUser.id
                    ? const Color(0xFFE8E8EE)
                    : const Color(0xFF1B97F3),
                tail: true,
                sent: false,
              ),
            );
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
