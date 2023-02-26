import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Произошла какая-то ошибка";
    try {
      if (likes.contains(uid)) {
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'Принято';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> postComment(String postId, String text, String uid,
      String name, String profilePic) async {
    String res = "Произошла какая-то ошибка";
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'Принято';
      } else {
        res = "Пожалуйста, введите текст";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> deletePost(String postId) async {
    String res = "Произошла какая-то ошибка";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'Принято';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> deleteTask(String taskId) async {
    String res = "Произошла какая-то ошибка";
    try {
      await _firestore.collection('tasks').doc(taskId).delete();
      res = 'Принято';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
