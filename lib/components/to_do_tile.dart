import 'package:flutter/material.dart';

class ToDoTile extends StatelessWidget {
  const ToDoTile({
    super.key,
    required this.title,
    required this.isCompleted,
    required this.onChanged,
    required this.popMenu,
  });

  final bool isCompleted;
  final String title;
  final void Function(bool?)? onChanged;
  final Widget? popMenu;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: isCompleted,
        onChanged: isCompleted ? null : onChanged,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          decoration: isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: popMenu,
    );
  }
}
