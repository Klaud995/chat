import 'package:chat/features/auth/controller/auth_controller.dart';
import 'package:chat/features/profile/screens/profile.dart';
import 'package:chat/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  static const routeName = '/settings-screen';
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  void signOut() {
    ref.read(authControllerProvider).signOut(context);
  }

  getProfileData() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    Navigator.pushNamed(
      context,
      ProfilePage.routeName,
      arguments: {'uidProfile': uid, 'isNotCurrentUserProfile': false},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ListTile(
                  onTap: getProfileData,
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.blue.shade100, shape: BoxShape.circle),
                    child: const Icon(CupertinoIcons.person,
                        color: Colors.blue, size: 35),
                  ),
                  title: const Text(
                    'Профиль',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ListTile(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      SelectContactsScreen.routeName,
                      arguments: {
                        'isChating': false,
                      },
                    );
                  },
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.green.shade100, shape: BoxShape.circle),
                    child: const Icon(CupertinoIcons.person_3,
                        color: Colors.green, size: 35),
                  ),
                  title: const Text(
                    'Список сотрудников',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded),
                ),
              ),
              const Divider(
                height: 40,
                color: Colors.black,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ListTile(
                  onTap: signOut,
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.redAccent.shade100,
                        shape: BoxShape.circle),
                    child: const Icon(Icons.logout,
                        color: Colors.redAccent, size: 35),
                  ),
                  title: const Text(
                    'Выйти из аккаунта',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
