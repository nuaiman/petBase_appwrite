class AppwriteConstants {
  static const String projectId = '64a51e755bca54cb8646';
  static const String databaseId = '64a51eb9af58b3885d4e';
  static const String endPoint = 'https://cloud.appwrite.io/v1';

  static const String usersCollection = '64a51f5187e1e5fd75be';
  static const String petsCollection = '64a51f5c33f8827670c3';
  // static const String chatsCollection = '6497f0108d905822de39';

  static const String imagesBucket = '64a51f3f0f01b2e0dc88';

  static String imageUrl(String imageId) =>
      '$endPoint/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectId&mode=admin';
}
