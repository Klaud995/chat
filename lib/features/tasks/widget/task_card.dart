import 'package:chat/common/resources/firestore_methods.dart';
import 'package:chat/features/tasks/styles/app_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskCard extends ConsumerStatefulWidget {
  final snap;
  const TaskCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  ConsumerState<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends ConsumerState<TaskCard> {
  int commentLen = 0;
  bool isLikeAnimating = false;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  deleteTask(String taskId) async {
    try {
      print(taskId);
      await FireStoreMethods().deleteTask(taskId);
    } catch (err) {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: widget.snap['isDone'] == true
              ? AppStyle.cardsColor[5]
              : AppStyle.cardsColor[4],
          borderRadius: BorderRadius.circular(8.0)),
      child: ListTile(
          title: Text(widget.snap['taskTitle'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppStyle.mainTitle),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Text(
              widget.snap['taskContent'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppStyle.mainContent,
            ),
          ),
          trailing: widget.snap['isDone']
              ? Icon(Icons.done)
              : IconButton(
                  onPressed: () {
                    deleteTask(
                      widget.snap['taskId'],
                    );
                  },
                  icon: const Icon(Icons.delete),
                )),
    );
  }
}
