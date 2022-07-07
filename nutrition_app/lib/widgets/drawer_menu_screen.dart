import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class MenuItem {
  final String title;
  final Icon icon;
  final int index;

  const MenuItem(this.title, this.icon, this.index);
}

class MenuItems {
  static const screen1 = MenuItem("Profile", Icon(Icons.person_outline_rounded), 3);
  static const screen2 = MenuItem("Statistics", Icon(Icons.auto_graph_outlined), 5);
  static const screen3 = MenuItem("Notifications", Icon(Icons.notifications_none_outlined), 4);
  static const screen4 = MenuItem("About Us", Icon(Icons.info_outline_rounded), 4);
  static const screen5 = MenuItem("Settings", Icon(Icons.settings_outlined), 4);

  static const all = <MenuItem> [
    screen1,
    screen2,
    screen3,
    screen4,
    screen5,
  ];
}

class DrawerMenuScreen extends StatelessWidget {
  final ValueChanged<MenuItem> onSelectedItem;

  const DrawerMenuScreen({
    Key? key,
    required this.onSelectedItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget> [
            const Spacer(),
            ...MenuItems.all.map( 
              (item) => buildMenuItem(context, item) 
            ).toList(),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem(BuildContext context, MenuItem item) {
    return ListTile(
      minLeadingWidth: 20,
      leading: item.icon,
      title: Text(
        item.title,
        style: Theme.of(context).textTheme.subtitle1?.copyWith(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      iconColor: Colors.white,
      onTap: () => onSelectedItem(item),
    );
  }
}