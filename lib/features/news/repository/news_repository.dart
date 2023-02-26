import 'dart:io';

import 'package:chat/common/repositories/common_firebase_storage_repository.dart';
import 'package:chat/common/utils/utils.dart';
import 'package:chat/models/post.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/features/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final addPostRepositoryProvider = Provider(
  (ref) => AddPostRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ),
);

class AddPostRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  AddPostRepository({
    required this.auth,
    required this.firestore,
  });

  void savePostDataToFirebase({
    required String titlePost,
    required String descriptionPost,
    required File? postPic,
    required ProviderRef ref,
    required BuildContext context,
  }) async {
    try {
      var userData =
          await firestore.collection('users').doc(auth.currentUser?.uid).get();

      UserModel user;
      user = UserModel.fromMap(userData.data()!);

      String uid = user.uid;
      String id = const Uuid().v1();

      String photoUrl = '';

      if (postPic != null) {
        photoUrl = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storeFileToFirebase(
              'posts/$uid/$id',
              postPic,
            );
      }
      String postId = const Uuid().v1();
      Post post = Post(
        postId: postId,
        uid: user.uid,
        username: user.name,
        profImage: user.profilePic,
        title: titlePost,
        description: descriptionPost,
        postUrl: photoUrl,
        datePublished: DateTime.now(),
        likes: [],
      );
      await firestore.collection('posts').doc(postId).set(post.toJson());
      await Navigator.pushNamedAndRemoveUntil(
          context, HomeScreen.routeName, (route) => false);
    } catch (e) {
      showSnackBar(
          context: context,
          content:
              'Неизвестная ошибка! Попробуйте еще раз или обратитесь в поддержку.');
      return;
    }
  }
}
