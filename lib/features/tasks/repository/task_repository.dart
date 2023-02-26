import 'package:chat/common/utils/utils.dart';
import 'package:chat/models/task.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/features/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final addTaskRepositoryProvider = Provider(
  (ref) => AddTaskRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ),
);

class AddTaskRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  AddTaskRepository({
    required this.auth,
    required this.firestore,
  });

  void saveTaskDataToFirebase({
    required String taskTitle,
    required String taskContent,
    required String creationDate,
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

      String taskId = const Uuid().v1();
      TaskModel task = TaskModel(
        taskId: taskId,
        uid: user.uid,
        taskTitle: taskTitle,
        taskContent: taskContent,
        creationDate: creationDate,
        isDone: false,
      );
      await firestore.collection('tasks').doc(taskId).set(task.toJson());
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

  void checkTaskDataToFirebase({
    required String taskId,
    required ProviderRef ref,
    required BuildContext context,
  }) async {
    try {
      var taskData = await firestore.collection('tasks').doc(taskId).get();

      TaskModel task;
      task = TaskModel.fromMap(taskData.data()!);

      TaskModel newTask = TaskModel(
        taskId: taskId,
        uid: task.uid,
        taskTitle: task.taskTitle,
        taskContent: task.taskContent,
        creationDate: task.creationDate,
        isDone: true,
      );

      await firestore.collection('tasks').doc(taskId).set(newTask.toJson());
      await Navigator.pushNamedAndRemoveUntil(
          context, HomeScreen.routeName, (route) => false);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
      return;
    }
  }
}
