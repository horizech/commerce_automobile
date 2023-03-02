import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/services/up_navigation.dart';
import 'package:flutter/material.dart';
import 'package:shop/constants.dart';

class AutomobileAppbar extends StatelessWidget implements PreferredSizeWidget {
  final int? collection;
  GlobalKey<ScaffoldState>? scaffoldKey;

  AutomobileAppbar({Key? key, this.collection, this.scaffoldKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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
    // UpAppBar(
    //   style: UpStyle(
    //     appBarColor: Colors.transparent,
    //   ),
    //   excludeHeaderSemantics: true,
    //   automaticallyImplyLeading: false,
    //   title: "Lazy Boy MCR",
    //   leading: width < 600
    //       ? IconButton(
    //           icon: const Icon(
    //             Icons.menu,
    //             color: Colors.white,
    //             size: 25,
    //           ),
    //           onPressed: () {
    //             scaffoldKey!.currentState!.openDrawer();
    //           },
    //         )
    //       : const Text(""),
    //   actions: [
    //     IconButton(
    //       onPressed: () {
    //         showSearch(
    //           context: context,
    //           delegate: CustomSearchDelegate(collectionId: collection),
    //         );
    //       },
    //       icon: const Icon(Icons.search),
    //     ),
    //     Visibility(
    //       visible: !Apiraiser.authentication.isSignedIn(),
    //       child: IconButton(
    //         onPressed: () {
    //           ServiceManager<UpNavigationService>().navigateToNamed(
    //             Routes.loginSignup,
    //           );
    //         },
    //         icon: const Icon(Icons.person),
    //       ),
    //     ),
    //     IconButton(
    //       onPressed: () {
    //         ServiceManager<UpNavigationService>().navigateToNamed(
    //           Routes.cart,
    //         );
    //       },
    //       icon: const Icon(Icons.shopping_bag),
    //     ),
    //   ],
    // );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
