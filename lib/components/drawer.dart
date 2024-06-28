import 'package:flutter/material.dart';
import 'package:notes/components/drawer_tile.dart';
import 'package:notes/pages/setting_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // header
          const DrawerHeader(child: Icon(Icons.edit,size: 110,)),
          SizedBox(height: 40,),
          // notes tile
          DrawerTile(
              leading: const Icon(Icons.home),
              title: "Notes",
              onTap: () => Navigator.pop(context)),
          // settings tile
          DrawerTile(
              leading: const Icon(Icons.settings),
              title: "Settings",
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingPage()));
              })
        ],
      ),
    );
  }
}
