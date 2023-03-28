import 'package:flutter/material.dart';
import 'package:flutter_up/widgets/up_app_bar.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/widgets/drawer/nav_drawer.dart';

class Admin extends StatelessWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: UpAppBar(),
      drawer: NavDrawer(),
      body: UpText("Admin"),
    );
  }
}
