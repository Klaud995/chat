import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/features/profile/screens/profile.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/features/select_contacts/controller/select_contact_controller.dart';
import 'package:chat/common/widgets/error.dart';
import 'package:chat/common/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectContactsScreen extends ConsumerStatefulWidget {
  static const String routeName = '/select-contact';

  final bool isChating;

  const SelectContactsScreen({
    super.key,
    required this.isChating,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectContactsScreen();
}

class _SelectContactsScreen extends ConsumerState<SelectContactsScreen> {
  Widget appBarTitle = new Text('Список сотрудников');
  Icon actionIcon = Icon(Icons.search);
  String searchText = '';

  void setSearchText(String value) {
    setState(() {
      searchText = value;
    });
  }

  void selectContact(WidgetRef ref, UserModel selectedContact, bool select,
      BuildContext context) {
    if (select) {
      if (widget.isChating) {
        ref
            .read(selectContactControllerProvider)
            .selectContact(selectedContact, context);
      } else {
        Navigator.pushNamed(
          context,
          ProfilePage.routeName,
          arguments: {
            'uidProfile': selectedContact.uid,
            'isNotCurrentUserProfile': true
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle,
        actions: <Widget>[
          new IconButton(
            icon: actionIcon,
            onPressed: () {
              setState(() {
                if (this.actionIcon.icon == Icons.search) {
                  this.actionIcon = Icon(Icons.close);
                  this.appBarTitle = Padding(
                    padding: const EdgeInsets.all(5),
                    child: TextField(
                      onChanged: (value) => setSearchText(value),
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          hintText: 'Поиск...',
                          hintStyle: TextStyle(color: Colors.white)),
                    ),
                  );
                } else {
                  this.appBarTitle = new Text('Список сотрудников');
                  this.actionIcon = Icon(Icons.search);
                }
                ;
              });
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: ref.watch(getContactsProvider).when(
              data: (contactList) => ListView.builder(
                  itemCount: contactList.length,
                  itemBuilder: (context, index) {
                    final contact = contactList[index];
                    if (contact.name.toLowerCase().contains(searchText))
                      return Column(children: [
                        InkWell(
                          onTap: () =>
                              selectContact(ref, contact, true, context),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: ListTile(
                              title: Text(
                                contact.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              leading: contact.profilePic == null
                                  ? null
                                  : CircleAvatar(
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                              contact.profilePic),
                                      radius: 30,
                                    ),
                            ),
                          ),
                        ),
                        Divider(color: Colors.black26),
                      ]);
                    else
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                      );
                  }),
              error: (err, trace) => ErrorScreen(error: err.toString()),
              loading: () => const Loader(),
            ),
      ),
    );
  }
}
