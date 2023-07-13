import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_base/features/auth/controller/auth_controller.dart';
import 'package:pet_base/features/chats/widgets/conversation_list_tile.dart';
import 'package:pet_base/models/conversation_model.dart';

import '../../../common/error_page.dart';
import '../../../common/loading_page.dart';
import '../controller/chats_controller.dart';

class ChatsView extends ConsumerWidget {
  const ChatsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentuser = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      body: ref.watch(getConversationsProvider(currentuser.id)).when(
            data: (data) {
              return ListView.separated(
                itemCount: data.length,
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.grey,
                  thickness: 0.2,
                ),
                itemBuilder: (context, index) =>
                    ConversationListTile(conversation: data[index]),
              );
            },
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            ),
          ),
    );
  }
}
