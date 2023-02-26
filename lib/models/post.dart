import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String postId;
  final String uid;
  final String username;
  final String profImage;
  final String title;
  final String description;
  final String postUrl;
  final DateTime datePublished;
  final likes;

  const Post({
    required this.postId,
    required this.uid,
    required this.username,
    required this.profImage,
    required this.title,
    required this.description,
    required this.postUrl,
    required this.datePublished,
    required this.likes,
  });

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
        postId: snapshot["postId"],
        uid: snapshot["uid"],
        username: snapshot["username"],
        profImage: snapshot['profImage'],
        title: snapshot["title"],
        description: snapshot["description"],
        postUrl: snapshot['postUrl'],
        datePublished: snapshot["datePublished"],
        likes: snapshot["likes"]);
  }

  Map<String, dynamic> toJson() => {
        "postId": postId,
        "uid": uid,
        "username": username,
        'profImage': profImage,
        "title": title,
        "description": description,
        'postUrl': postUrl,
        "datePublished": datePublished,
        "likes": likes
      };
}
