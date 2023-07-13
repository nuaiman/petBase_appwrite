import 'package:pet_base/constants/project_id_secret_pass.dart';

class AppwriteConstants {
  static const String projectId = projectIdSecretPass;
  static const String databaseId = '64a51eb9af58b3885d4e';
  static const String endPoint = 'https://cloud.appwrite.io/v1';

  static const String usersCollection = '64afd23104400d621c53';
  static const String petsCollection = '64a51f5c33f8827670c3';
  static const String conversationsCollection = '64afcc3d1cf371cf7102';
  static const String chatsCollection = '64afa7ce626f26ddb5a5';

  static const String imagesBucket = '64a51f3f0f01b2e0dc88';

  static String imageUrl(String imageId) =>
      '$endPoint/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectId&mode=admin';
}
