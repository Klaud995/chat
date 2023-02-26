import 'package:chat/features/news/screens/add_news_screen.dart';
import 'package:chat/features/news/screens/news_screen.dart';
import 'package:chat/features/chat/widgets/contacts_list.dart';
import 'package:chat/features/group/screens/create_group_screen.dart';
import 'package:chat/features/settings/screens/settings.dart';
import 'package:chat/features/tasks/screens/task_add.dart';
import 'package:chat/features/tasks/screens/tasks_screen.dart';
import 'package:chat/features/auth/controller/auth_controller.dart';
import 'package:chat/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static const routeName = '/home-screen';

  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver {
  int _selectedTab = 0;
  final pages = const [
    NewsScreen(),
    ContactsList(),
    TasksScreen(),
    SettingsScreen(),
  ];

  final ValueNotifier<int> pageIndex = ValueNotifier(0);

  static const List<Widget> _widgetOptions = <Widget>[
    Text('Новости'),
    Text('Сообщения'),
    Text('Задачи'),
    Text('Еще'),
  ];

  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserState(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        ref.read(authControllerProvider).setUserState(false);
        break;
    }
  }

  void onSelectedTab(int index) {
    if (_selectedTab == index) return;
    setState(() {
      _selectedTab = index;
      pageIndex.value = _selectedTab;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: _widgetOptions[_selectedTab],
          actions: [
            PopupMenuButton(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: const Text(
                    'Создать групповой чат',
                  ),
                  onTap: () => Future(
                    () => Navigator.pushNamed(
                        context, CreateGroupScreen.routeName),
                  ),
                )
              ],
            ),
          ],
        ),
        body: ValueListenableBuilder(
            valueListenable: pageIndex,
            builder: (BuildContext context, int value, _) {
              return pages[value];
            }),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedTab,
          items: [
            BottomNavigationBarItem(
              backgroundColor: Color(0xFF30a2f3),
              icon: Icon(
                CupertinoIcons.news,
              ),
              label: 'Новости',
            ),
            BottomNavigationBarItem(
              backgroundColor: Color(0xFF30a2f3),
              icon: Icon(
                CupertinoIcons.chat_bubble_2,
              ),
              label: 'Сообщения',
            ),
            BottomNavigationBarItem(
              backgroundColor: Color(0xFF30a2f3),
              icon: Icon(
                CupertinoIcons.hammer,
              ),
              label: 'Задачи',
            ),
            BottomNavigationBarItem(
              backgroundColor: Color(0xFF30a2f3),
              icon: Icon(
                CupertinoIcons.gear,
              ),
              label: 'Еще',
            ),
          ],
          onTap: onSelectedTab,
        ),
        floatingActionButton: pageIndex.value != 3
            ? FloatingActionButton(
                onPressed: () async {
                  if (pageIndex.value == 0) {
                    Navigator.pushNamed(
                      context,
                      AddPostTypeScreen.routeName,
                    );
                  }
                  if (pageIndex.value == 1) {
                    Navigator.pushNamed(
                      context,
                      SelectContactsScreen.routeName,
                      arguments: {
                        'isChating': true,
                      },
                    );
                  }
                  if (pageIndex.value == 2) {
                    Navigator.pushNamed(
                      context,
                      TaskAddScreen.routeName,
                    );
                  }
                },
                backgroundColor: Colors.red.shade400,
                child: const Icon(
                  CupertinoIcons.plus_square,
                  color: Colors.white,
                ),
              )
            : null);
  }
}
