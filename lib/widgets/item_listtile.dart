import 'package:flutter/material.dart';

class ItemListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback editFunction;
  final VoidCallback deleteFunction;
  final String? subtitle;
  final VoidCallback callback;
  const ItemListTile({
    super.key,
    required this.icon,
    required this.title,
    required this.editFunction,
    required this.deleteFunction,
    this.subtitle,
    required this.callback,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          icon,
          size: 30,
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
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: PopupMenuButton(
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'edit',
            child: Row(
              children: [
                Icon(Icons.edit, color: Colors.black54, size: 20),
                SizedBox(width: 10),
                Text('Edit'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete, color: Colors.black54, size: 20),
                SizedBox(width: 10),
                Text('Delete'),
              ],
            ),
          ),
        ],
        onSelected: (value) {
          if (value == 'edit') {
            editFunction();
          } else if (value == 'delete') {
            deleteFunction();
          }
        },
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
