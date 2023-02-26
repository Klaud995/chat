import 'package:chat/common/widgets/loader.dart';
import 'package:chat/features/auth/controller/auth_controller.dart';
import 'package:chat/features/profile/widget/info_card.dart';
import 'package:chat/features/select_contacts/controller/select_contact_controller.dart';
import 'package:chat/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends ConsumerStatefulWidget {
  static const routeName = '/profile-screen';
  final String uid;
  final bool isNotCurrentUser;

  ProfilePage({required this.uid, required this.isNotCurrentUser});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  void openChat(WidgetRef ref, String uid, BuildContext context) {
    ref.read(selectContactControllerProvider).selectContact2(uid, context);
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Профиль"),
        ),
        body: StreamBuilder<UserModel>(
            stream: ref.read(authControllerProvider).userDataById(widget.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Loader();
              }
              return SafeArea(
                minimum: const EdgeInsets.only(top: 20),
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: NetworkImage(snapshot.data!.profilePic),
                    ),
                    Text(
                      snapshot.data!.name,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Pacifico",
                      ),
                    ),
                    widget.isNotCurrentUser
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ListTile(
                              onTap: () => openChat(ref, widget.uid, context),
                              title: const Center(
                                child: Text(
                                  'Открыть чат',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                          )
                        : SizedBox(height: 0),
                    SizedBox(
                      height: 20,
                      width: 200,
                      child: Divider(
                        color: Colors.white,
                      ),
                    ),
                    InfoCard(
                      text: snapshot.data!.email,
                      icon: Icons.email,
                    ),
                    InfoCard(
                      text: snapshot.data!.phoneNumber,
                      icon: Icons.phone,
                    ),
                    InfoCard(
                      text: snapshot.data!.birthDate,
                      icon: Icons.calendar_month,
                    ),
                    InfoCard(
                      text: snapshot.data!.subdivision,
                      icon: CupertinoIcons.folder_fill_badge_person_crop,
                    ),
                    InfoCard(
                      text: snapshot.data!.jobTitle,
                      icon: CupertinoIcons.doc_person_fill,
                    ),
                  ],
                ),
              );
            }));
  }
}
