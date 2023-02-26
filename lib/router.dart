import 'package:chat/features/news/screens/add_news_screen.dart';
import 'package:chat/features/news/screens/news_screen.dart';
import 'package:chat/features/auth/screens/login_screen.dart';
import 'package:chat/features/auth/screens/reset_password.dart';
import 'package:chat/features/chat/screens/chat_screen.dart';
import 'package:chat/features/group/screens/create_group_screen.dart';
import 'package:chat/features/home_screen.dart';
import 'package:chat/features/profile/screens/profile.dart';
import 'package:chat/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:chat/features/tasks/screens/task_add.dart';
import 'package:chat/features/tasks/screens/task_reader.dart';
import 'package:flutter/material.dart';
import 'package:chat/common/widgets/error.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const AuthScreen(),
      );
    case HomeScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => HomeScreen(),
      );
    case ResetPasswordScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => ResetPasswordScreen(),
      );
    case SelectContactsScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final isChating = arguments['isChating'];
      return MaterialPageRoute(
        builder: (context) => SelectContactsScreen(
          isChating: isChating,
        ),
      );
    case NewsScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => NewsScreen(),
      );
    case TaskAddScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => TaskAddScreen(),
      );
    case TaskReaderScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final taskData = arguments['taskData'];
      return MaterialPageRoute(
        builder: (context) => TaskReaderScreen(taskData),
      );
    case ProfilePage.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final uidProfile = arguments['uidProfile'];
      final isNotCurrentUserProfile = arguments['isNotCurrentUserProfile'];
      return MaterialPageRoute(
        builder: (context) => ProfilePage(
            uid: uidProfile, isNotCurrentUser: isNotCurrentUserProfile),
      );
    case ChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments['name'];
      final uid = arguments['uid'];
      final isGroupChat = arguments['isGroupChat'];
      final profilePic = arguments['profilePic'];
      return MaterialPageRoute(
        builder: (context) => ChatScreen(
          name: name,
          uid: uid,
          isGroupChat: isGroupChat,
          profilePic: profilePic,
        ),
      );
    case CreateGroupScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const CreateGroupScreen(),
      );
    case AddPostTypeScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const AddPostTypeScreen(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(error: 'This page doesn\'t exist'),
        ),
      );
  }
}
