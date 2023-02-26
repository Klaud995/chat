import 'dart:io';

import 'package:chat/common/repositories/common_firebase_storage_repository.dart';
import 'package:chat/common/utils/utils.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/features/auth/screens/login_screen.dart';
import 'package:chat/features/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ),
);

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  AuthRepository({
    required this.auth,
    required this.firestore,
  });

  Future<void> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushNamedAndRemoveUntil(
          context, HomeScreen.routeName, (route) => false);
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        showSnackBar(
          context: context,
          content: 'Неправильный email или пароль. Повторите попытку',
        );
        return;
      } else {
        showSnackBar(
            context: context,
            content:
                'Неизвестная ошибка! Попробуйте еще раз или обратитесь в поддержку.');
        return;
      }
    }
  }

  Future<void> resetPassword(BuildContext context, String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      Navigator.pushNamedAndRemoveUntil(
          context, AuthScreen.routeName, (route) => false);
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'user-not-found') {
        showSnackBar(
          context: context,
          content:
              'Пользователя с таким адресом электронной почты не существует',
        );
        return;
      } else {
        showSnackBar(
            context: context,
            content:
                'Неизвестная ошибка! Попробуйте еще раз или обратитесь в поддержку.');
        return;
      }
    }
  }

  Future<UserModel> getCurrentUserData2() async {
    var userData =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();

    UserModel user;
    user = UserModel.fromMap(userData.data()!);
    return user;
  }

  Future<UserModel?> getCurrentUserData() async {
    var userData =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();

    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  void saveUserDataToFirebase({
    required String email,
    required String name,
    required String birthDate,
    required String phoneNumber,
    required String subdivision,
    required String jobTitle,
    required File? profilePic,
    required ProviderRef ref,
    required BuildContext context,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl =
          'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';

      if (profilePic != null) {
        photoUrl = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storeFileToFirebase(
              'profilePic/$uid',
              profilePic,
            );
      }

      var user = UserModel(
        uid: uid,
        email: email,
        name: name,
        birthDate: birthDate,
        phoneNumber: phoneNumber,
        subdivision: subdivision,
        jobTitle: jobTitle,
        profilePic: photoUrl,
        isOnline: true,
        groupId: [],
      );

      await firestore.collection('users').doc(uid).set(user.toMap());

      Navigator.pushNamedAndRemoveUntil(
        context,
        AuthScreen.routeName,
        (route) => false,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await auth.signOut();
      await Navigator.pushNamedAndRemoveUntil(
          context, AuthScreen.routeName, (route) => false);
      return;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      showSnackBar(
          context: context,
          content:
              'Неизвестная ошибка! Попробуйте еще раз или обратитесь в поддержку.');
      return;
    }
  }

  Stream<UserModel> userData(String userId) {
    return firestore.collection('users').doc(userId).snapshots().map(
          (event) => UserModel.fromMap(
            event.data()!,
          ),
        );
  }

  Stream<UserModel> getCurrentUserData3() {
    return firestore
        .collection('users')
        .doc(auth.currentUser?.uid)
        .snapshots()
        .map(
          (event) => UserModel.fromMap(
            event.data()!,
          ),
        );
  }

  void setUserState(bool isOnline) async {
    await firestore.collection('users').doc(auth.currentUser!.uid).update({
      'isOnline': isOnline,
    });
  }
}
