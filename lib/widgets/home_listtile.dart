import 'package:flutter/material.dart';

class HomeListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback callback;
  const HomeListTile(
      {super.key,
      required this.icon,
      required this.title,
      required this.callback});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          icon,
          size: 25,
          color: Colors.white,
        ),
      ), // Icon on the left
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
      ), // Title text
      trailing: const Icon(
        Icons.chevron_right_sharp,
        size: 30,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      iconColor: Theme.of(context).primaryColor,
      autofocus: true,
      onTap: callback,
    );
  }
}
