import 'package:flutter/material.dart';
import 'package:flutter_up/widgets/up_scaffold.dart';
import 'package:shop/widgets/appbar/automobile_appbar.dart';
import 'package:shop/widgets/drawer/menu_drawer.dart';
import 'package:shop/widgets/search/search_widget.dart';

class SearchPage extends StatefulWidget {
  final Map<String, String>? queryParams;
  const SearchPage({
    this.queryParams,
    Key? key,
  }) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return UpScaffold(
      scaffoldKey: scaffoldKey,
      drawer: const MenuDrawer(),
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,
      body: Column(
        children: [
          AutomobileAppbar(
            scaffoldKey: scaffoldKey,
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height: 80),
                SizedBox(
                  child: SearchWidget(
                    collection: 9,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
