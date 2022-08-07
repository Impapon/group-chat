import 'package:firebase_day36/auth/firebase_auth.dart';
import 'package:firebase_day36/providers/user_provider.dart';
import 'package:firebase_day36/widgets/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserListPage extends StatefulWidget {
  static const String routeName = 'userList';

  const UserListPage({Key? key}) : super(key: key);

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  bool isFirst = true;

  @override
  void didChangeDependencies() {
    if (isFirst) {
      Provider.of<UserProvider>(context, listen: false)
          .getAllRemainingUser(AuthService.user!.uid);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: const Text("user List"),
      ),
    );
  }
}
