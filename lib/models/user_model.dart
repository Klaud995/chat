import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String name;
  final String birthDate;
  final String phoneNumber;
  final String subdivision;
  final String jobTitle;
  final String profilePic;
  final bool isOnline;
  final List<String> groupId;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.birthDate,
    required this.phoneNumber,
    required this.subdivision,
    required this.jobTitle,
    required this.profilePic,
    required this.isOnline,
    required this.groupId,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'birthDate': birthDate,
      'phoneNumber': phoneNumber,
      'subdivision': subdivision,
      'jobTitle': jobTitle,
      'profilePic': profilePic,
      'isOnline': isOnline,
      'groupId': groupId,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      birthDate: map['birthDate'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      subdivision: map['subdivision'],
      jobTitle: map['jobTitle'],
      profilePic: map['profilePic'] ?? '',
      isOnline: map['isOnline'] ?? false,
      groupId: List<String>.from(map['groupId']),
    );
  }

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
        uid: snapshot["uid"],
        email: snapshot["email"],
        name: snapshot["name"],
        birthDate: snapshot["dateBirth"],
        phoneNumber: snapshot["phoneNumber"],
        subdivision: snapshot["subdivision"],
        jobTitle: snapshot["jobTitle"],
        profilePic: snapshot["profilePic"],
        isOnline: snapshot["isOnline"],
        groupId: snapshot["groupId"]);
  }
}
