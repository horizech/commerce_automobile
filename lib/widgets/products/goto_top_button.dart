import 'dart:developer';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/locator.dart';
import 'package:shop/widgets/products/scroll_to_top_service.dart';

class GoToTopButtonWidget extends StatefulWidget {
  @override
  State<GoToTopButtonWidget> createState() => _GoToTopButtonWidgetState();
}

class _GoToTopButtonWidgetState extends State<GoToTopButtonWidget> {
  bool showButton = false;
  // @override
  // void initState() {
  //   super.initState();
  //   if () {
  //     setState(() {
  //       showButton = true;
  //     });
  //   } else {
  //     setState(() {
  //       showButton = false;
  //     });
  //   }
  //   print(widget.offset);
  // }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
        stream: ServiceManager<ScrollToTopService>().offsetStream$,
        builder: (BuildContext context, offsetSnapshot) {
          return Visibility(
            visible:
                offsetSnapshot.hasData && (offsetSnapshot.data ?? 0) >= 400,
            child: FloatingActionButton(
              backgroundColor: UpConfig.of(context).theme.primaryColor,
              onPressed: () {
                ServiceManager<ScrollToTopService>().goUp();
              },
              child: const Icon(Icons.arrow_upward),
            ),
          );
        });
  }
}
