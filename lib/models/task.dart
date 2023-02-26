class TaskModel {
  final String taskId;
  final String uid;
  final String taskTitle;
  final String taskContent;
  final String creationDate;
  final bool isDone;

  const TaskModel({
    required this.taskId,
    required this.uid,
    required this.taskTitle,
    required this.taskContent,
    required this.creationDate,
    required this.isDone,
  });

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      taskId: map['taskId'] ?? '',
      uid: map['uid'] ?? '',
      taskTitle: map['taskTitle'] ?? '',
      taskContent: map['taskContent'] ?? '',
      creationDate: map['creationDate'] ?? '',
      isDone: map['isDone'],
    );
  }

  Map<String, dynamic> toJson() => {
        "taskId": taskId,
        "uid": uid,
        "taskTitle": taskTitle,
        "taskContent": taskContent,
        "creationDate": creationDate,
        "isDone": isDone
      };
}
