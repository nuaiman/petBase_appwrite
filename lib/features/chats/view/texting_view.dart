import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/controller/auth_controller.dart';
import '../../../models/conversation_model.dart';

import '../../../models/user_model.dart';
import '../controller/chats_controller.dart';
import '../widgets/text_list.dart';

class TextingView extends ConsumerStatefulWidget {
  const TextingView({
    super.key,
    required this.conversation,
  });

  final ConversationModel conversation;

  @override
  ConsumerState<TextingView> createState() => _TextingViewState();
}

class _TextingViewState extends ConsumerState<TextingView> {
  final _textController = TextEditingController();
  late UserModel currentUser;

  @override
  void initState() {
    currentUser = ref.read(authControllerProvider);
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 45,
          leading: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                currentUser.imageUrl == widget.conversation.ownerImageUrl
                    ? widget.conversation.requestingUserImageUrl
                    : widget.conversation.ownerImageUrl,
              ),
            ),
          ),
          centerTitle: false,
          title: Text(
            currentUser.name == widget.conversation.ownerName
                ? widget.conversation.requestingUserName
                : widget.conversation.ownerName,
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: TextList(
                conversation: widget.conversation,
              ),
            ),
            Container(
              width: double.infinity,
              height: 80,
              color: Colors.grey.shade100,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: InputBorder.none,
                          hintText: 'Send messages',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: IconButton(
                            onPressed: () {
                              if (_textController.text.trim().isEmpty) {
                                return;
                              }
                              ref
                                  .read(chatsControllerProvider.notifier)
                                  .sendText(
                                    context: context,
                                    conversationId:
                                        widget.conversation.identifier,
                                    text: _textController.text,
                                  );

                              _textController.clear();
                            },
                            icon: const Icon(
                              Icons.send,
                              color: Colors.indigoAccent,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
