import 'package:chat/common/utils/utils.dart';
import 'package:chat/features/tasks/controller/task_controller.dart';
import 'package:chat/features/tasks/styles/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskReaderScreen extends ConsumerStatefulWidget {
  static const String routeName = '/tasks-reader-screen';
  final doc;
  TaskReaderScreen(this.doc, {Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TaskReaderScreen();
}

class _TaskReaderScreen extends ConsumerState<TaskReaderScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  checkTask() {
    try {
      ref.read(addTaskControllerProvider).checkTaskDataToFirebase(
            context,
            widget.doc['taskId'],
          );
    } catch (e) {
      print(e);
      showSnackBar(
          context: context,
          content:
              'Неизвестная ошибка! Попробуйте еще раз или обратитесь в поддержку.');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: widget.doc['isDone'] == true
            ? AppStyle.cardsColor[5]
            : AppStyle.cardsColor[4],
        appBar: AppBar(
          backgroundColor: widget.doc['isDone'] == true
              ? AppStyle.cardsColor[5]
              : AppStyle.cardsColor[4],
          elevation: 0.0,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(widget.doc['taskTitle'], style: AppStyle.mainTitle),
              Text(widget.doc['creationDate']),
              Text(widget.doc['taskContent'], style: AppStyle.mainTitle),
            ]),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: checkTask(),
          backgroundColor: Colors.red.shade400,
          child: const Icon(Icons.save),
        ));
  }
}
