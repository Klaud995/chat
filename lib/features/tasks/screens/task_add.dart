import 'dart:math';

import 'package:chat/common/utils/utils.dart';
import 'package:chat/features/tasks/controller/task_controller.dart';
import 'package:chat/features/tasks/styles/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class TaskAddScreen extends ConsumerStatefulWidget {
  static const String routeName = '/tasks-add-screen';
  TaskAddScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TaskAddScreen();
}

class _TaskAddScreen extends ConsumerState<TaskAddScreen> {
  String date = DateFormat('dd.MM.yyyy kk:mm').format(DateTime.now());
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  int color_id = 4;

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
  }

  void storeTask() {
    String title = _titleController.text.trim();
    String description = _descriptionController.text.trim();

    if (title.isNotEmpty && description.isNotEmpty) {
      try {
        ref
            .read(addTaskControllerProvider)
            .saveTaskDataToFirebase(context, title, description, date);
      } catch (e) {
        print(e);
        showSnackBar(
            context: context,
            content:
                'Неизвестная ошибка! Попробуйте еще раз или обратитесь в поддержку.');
        return;
      }
      ;
    } else {
      showSnackBar(
          context: context, content: 'Не указны название и описание задачи');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppStyle.cardsColor[color_id],
        appBar: AppBar(
          backgroundColor: AppStyle.cardsColor[color_id],
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0.0,
          title: Text(
            'Добавить новую задачу',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: 'Название задачи'),
                style: AppStyle.mainTitle,
                maxLength: 30,
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                date,
                style: AppStyle.mainDate,
              ),
              SizedBox(
                height: 28,
              ),
              TextField(
                controller: _descriptionController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: 'Описание задачи'),
                style: AppStyle.mainContent,
              )
            ]),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: storeTask,
          backgroundColor: Colors.red.shade400,
          child: const Icon(Icons.save),
        ));
  }
}
