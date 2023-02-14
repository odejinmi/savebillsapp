import 'package:flutter/material.dart';

import 'constant.dart';
import 'web_view_container.dart';

class Bottomnavigation extends StatelessWidget {
  final int selected;
  const Bottomnavigation({Key? key, this.selected = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        for (int i = 0; i < bottomicon.length; i++)
          GestureDetector(
            child: Container(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Icon(
                    getIcon(bottomicon[i]),
                    color: selected == i ? primarycolor : Colors.black,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    bottomtittle[i],
                    style: TextStyle(
                        color: selected == i ? primarycolor : Colors.black),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            onTap: () {
              // url = bottomurl[i];
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => WebViewContainer()));
            },
          )
      ],
    );
  }

  getIcon(icon) {
    switch (icon) {
      case "Icons.add_shopping_cart":
        return Icons.add_shopping_cart;
      case "Icons.history":
        return Icons.history;
      case "Icons.home":
        return Icons.home;
      case "Icons.call_made":
        return Icons.call_made;
      case "Icons.account_balance_wallet":
        return Icons.account_balance_wallet;
      case "Icons.add":
        return Icons.add;
      case "Icons.search":
        return Icons.search;
      case "Icons.security":
        return Icons.security;
      case "Icons.access_time":
        return Icons.access_time;
      case "Icons.add_alert_rounded":
        return Icons.add_alert_rounded;
      case "Icons.account_balance_rounded":
        return Icons.account_balance_rounded;
      case "Icons.contact_mail":
        return Icons.contact_mail;
      case "Icons.help":
        return Icons.help;
      case "Icons.settings":
        return Icons.settings;
      case "Icons.headphones":
        return Icons.headphones;
      case "Icons.key":
        return Icons.key;
    }
  }
}
