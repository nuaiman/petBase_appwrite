// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../../models/user_model.dart';
// import '../view/texting_view.dart';

// class UserListTile extends ConsumerWidget {
//   const UserListTile({super.key, required this.user});

//   final UserModel user;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final currentUser = ref.watch(userProfileControllerProvider);
//     return ListTile(
//       onTap: () {
//         Navigator.of(context).push(MaterialPageRoute(
//           builder: (context) => TextingView(
//             otherUser: user,
//             currentUser: currentUser,
//           ),
//         ));
//       },
//       leading: CircleAvatar(
//         backgroundImage: NetworkImage(user.imageUrl),
//       ),
//       title: Text(user.name),
//     );
//   }
// }
