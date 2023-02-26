import 'package:chat/common/widgets/loader.dart';
import 'package:chat/features/tasks/screens/task_reader.dart';
import 'package:chat/features/tasks/widget/task_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TasksScreen extends ConsumerStatefulWidget {
  static const String routeName = '/tasks-screen';
  const TasksScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TasksScreen();
}

class _TasksScreen extends ConsumerState<TasksScreen> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('tasks')
            .where('uid', isEqualTo: uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loader();
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) => Container(
              margin: EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 0,
              ),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    TaskReaderScreen.routeName,
                    arguments: {
                      'taskData': snapshot.data!.docs[index].data(),
                    },
                  );
                },
                child: TaskCard(
                  snap: snapshot.data!.docs[index].data(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
