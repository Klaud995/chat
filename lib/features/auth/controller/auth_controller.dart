import 'dart:io';
import 'package:chat/models/user_model.dart';
import 'package:chat/features/auth/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
});

final userDataAuthProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getUserData();
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;
  AuthController({
    required this.authRepository,
    required this.ref,
  });

  void signInWithEmailAndPassword(
      BuildContext context, String email, String password) {
    authRepository.signInWithEmailAndPassword(context, email, password);
  }

  void resetPassword(BuildContext context, String email) {
    authRepository.resetPassword(context, email);
  }

  Future<UserModel?> getUserData2() async {
    UserModel user = await authRepository.getCurrentUserData2();
    return user;
  }

  Stream<UserModel> getUserData3() {
    return authRepository.getCurrentUserData3();
  }

  Future<UserModel?> getUserData() async {
    UserModel? user = await authRepository.getCurrentUserData();
    return user;
  }

  void saveUserDataToFirebase(
      BuildContext context,
      String email,
      String name,
      String birthDate,
      String number,
      String subdivision,
      String jobTitle,
      File? profilePic) {
    authRepository.saveUserDataToFirebase(
      email: email,
      name: name,
      birthDate: birthDate,
      phoneNumber: number,
      subdivision: subdivision,
      jobTitle: jobTitle,
      profilePic: profilePic,
      ref: ref,
      context: context,
    );
  }

  Future<void> signOut(BuildContext context) async {
    await authRepository.signOut(context);
  }

  Stream<UserModel> userDataById(String userId) {
    return authRepository.userData(userId);
  }

  void setUserState(bool isOnline) {
    authRepository.setUserState(isOnline);
  }
}
