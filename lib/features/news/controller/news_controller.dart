import 'dart:io';
import 'package:chat/features/news/repository/news_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final addPostControllerProvider = Provider((ref) {
  final addPostRepository = ref.watch(addPostRepositoryProvider);
  return addPostController(addPostRepository: addPostRepository, ref: ref);
});

class addPostController {
  final AddPostRepository addPostRepository;
  final ProviderRef ref;
  addPostController({
    required this.addPostRepository,
    required this.ref,
  });

  void savePostDataToFirebase(BuildContext context, String titlePost,
      String descriptionPost, File? postPic) {
    addPostRepository.savePostDataToFirebase(
      titlePost: titlePost,
      descriptionPost: descriptionPost,
      postPic: postPic,
      ref: ref,
      context: context,
    );
  }
}
