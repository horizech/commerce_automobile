import 'package:flutter/material.dart';
import 'package:shop/widgets/appbar/automobile_appbar.dart';
import 'package:shop/widgets/drawer/MenuDrawer.dart';
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
    return Scaffold(
      key: scaffoldKey,
      drawer: const MenuDrawer(),
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,
      body: Column(
        children: [
          AutomobileAppbar(
            scaffoldKey: scaffoldKey,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                children: const [
                  SizedBox(
                    height: 250,
                    width: 400,
                    child: SearchWidget(),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
