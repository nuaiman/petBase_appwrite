import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/conversation_model.dart';
import '../../auth/controller/auth_controller.dart';
import '../view/texting_view.dart';

class ConversationListTile extends ConsumerWidget {
  const ConversationListTile({super.key, required this.conversation});

  final ConversationModel conversation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authControllerProvider);
    return Card(
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => TextingView(
              conversation: conversation,
            ),
          ));
        },
        // leading: CircleAvatar(
        //   backgroundImage: NetworkImage(user.imageUrl),
        // ),
        title: Text(currentUser.name != conversation.ownerName
            ? conversation.ownerName
            : conversation.requestingUserName),
      ),
    );
  }
}
