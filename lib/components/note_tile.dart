import 'package:flutter/material.dart';
import 'package:notes/components/note_settings.dart';
import 'package:popover/popover.dart';

class NoteTile extends StatelessWidget {
  final String text;
  final void Function()? onEditPressed;
  final void Function()? onDeletePressed;
  const NoteTile({super.key, required this.text,required this.onDeletePressed, required this.onEditPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(7)),
        margin: EdgeInsets.only(top: 10, right: 25, left: 25),
        child: ListTile(
          title: Text(text),
          trailing: Builder(
            builder: (context) {
              return IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () => showPopover(
                  width: 100,
                  height: 100,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  context: context,
                   bodyBuilder: (context) => NoteSettings(onDeleteTap: onDeletePressed,onEditTap: onEditPressed,)),
              );
            }
          )
        ));
  }
}
