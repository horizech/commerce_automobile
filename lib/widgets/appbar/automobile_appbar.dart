import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/services/up_navigation.dart';
import 'package:flutter/material.dart';
import 'package:shop/constants.dart';

class AutomobileAppbar extends StatelessWidget implements PreferredSizeWidget {
  final int? collection;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const AutomobileAppbar({Key? key, this.collection, this.scaffoldKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: UpConfig.of(context).theme.primaryColor),
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
              size: 25,
            ),
            onPressed: () {
              scaffoldKey!.currentState!.openDrawer();
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                ServiceManager<UpNavigationService>()
                    .navigateToNamed(Routes.home);
              },
              child: const MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Image(
                  image: AssetImage("assets/logo.png"),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              ServiceManager<UpNavigationService>()
                  .navigateToNamed(Routes.searchAutomobile);
            },
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
