import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/error_page.dart';
import '../../../common/loading_page.dart';
import '../widgets/user_list_tile.dart';

class ChatsView extends ConsumerWidget {
  const ChatsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final currentuser = ref.watch(userProfileControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        // leadingWidth: 45,
        // leading: Padding(
        //   padding: const EdgeInsets.only(left: 8.0),
        //   child: CircleAvatar(
        //       // backgroundImage: NetworkImage(currentuser.profilePic),
        //       ),
        // ),
        // centerTitle: false,

        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       // ref.read(authControllerProvider.notifier).logout(context);
        //     },
        //     icon: const Icon(Icons.power_settings_new),
        //   ),
        // ],
      ),
      // body: ref.watch(getUsersProvider).when(
      //       data: (data) {
      //         return ListView.separated(
      //           itemCount: data.length,
      //           separatorBuilder: (context, index) => const Divider(
      //             color: Colors.grey,
      //             thickness: 0.2,
      //           ),
      //           itemBuilder: (context, index) =>
      //               UserListTile(user: data[index]),
      //         );
      //       },
      //       error: (error, stackTrace) => ErrorText(error: error.toString()),
      //       loading: () => const Loader(),
      //     ),
    );
  }
}
