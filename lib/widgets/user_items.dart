import 'package:firebase_day36/models/user_model.dart';
import 'package:flutter/material.dart';

class UserItem extends StatelessWidget {
  final UserModel userModel;

  const UserItem({Key? key, required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipOval(
        child: Card(
          child: userModel.image == null
              ? Image.asset(
                  'images/man.jpeg',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )
              : Image.network(userModel.image!),
        ),
      ),
      title: Text(userModel.name ?? userModel.email),
      subtitle: Text(
        userModel.available ? "Online" : "Offline",
        style:
            TextStyle(color: userModel.available ? Colors.amber : Colors.grey),
      ),
    );
  }
}
