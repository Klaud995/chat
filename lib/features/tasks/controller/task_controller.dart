import 'package:chat/features/tasks/repository/task_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final addTaskControllerProvider = Provider((ref) {
  final addTaskRepository = ref.watch(addTaskRepositoryProvider);
  return AddTaskController(addTaskRepository: addTaskRepository, ref: ref);
});

class AddTaskController {
  final AddTaskRepository addTaskRepository;
  final ProviderRef ref;
  AddTaskController({
    required this.addTaskRepository,
    required this.ref,
  });

  void saveTaskDataToFirebase(BuildContext context, String taskTitle,
      String taskContent, String creationDate) {
    addTaskRepository.saveTaskDataToFirebase(
      taskTitle: taskTitle,
      taskContent: taskContent,
      creationDate: creationDate,
      ref: ref,
      context: context,
    );
  }

  void checkTaskDataToFirebase(
    BuildContext context,
    String taskId,
  ) {
    addTaskRepository.checkTaskDataToFirebase(
      taskId: taskId,
      ref: ref,
      context: context,
    );
  }
}
