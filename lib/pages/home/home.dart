import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/models/product_option_value.dart';
import 'package:shop/widgets/appbar/automobile_appbar.dart';
import 'package:shop/widgets/drawer/MenuDrawer.dart';
import 'package:shop/widgets/search/search_by_body.dart';
import 'package:shop/widgets/search/search_widget.dart';
import 'package:shop/widgets/store/store_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ProductOptionValue> productOptionValues = [];
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int? collection;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: UpConfig.of(context).theme.secondaryColor,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        key: scaffoldKey,
        drawer: const MenuDrawer(),
        drawerEnableOpenDragGesture: false,
        endDrawerEnableOpenDragGesture: false,
        body: BlocConsumer<StoreCubit, StoreState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state.collections != null && state.collections!.isNotEmpty) {
              collection = state.collections!
                  .where((element) => element.name == "Used Cars")
                  .first
                  .id;
            }
            if (state.productOptions != null &&
                state.productOptions!.isNotEmpty) {
              int? productOption = state.productOptions!
                  .where((element) => element.name == "Body Type")
                  .first
                  .id;
              if (productOption != null && collection != null) {
                if (state.productOptionValues != null &&
                    state.productOptionValues!.isNotEmpty) {
                  if (state.productOptions != null &&
                      state.productOptions!.isNotEmpty) {
                    productOptionValues = state.productOptionValues!
                        .where(
                          (element) =>
                              element.collection == collection &&
                              element.productOption == productOption,
                        )
                        .toList();
                  }
                }
              }
            }
            return Column(
              children: [
                AutomobileAppbar(
                  scaffoldKey: scaffoldKey,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        Container(),
                        Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        UpConfig.of(context).theme.primaryColor,
                                    width: 4,
                                  ),
                                  color:
                                      const Color.fromARGB(64, 249, 153, 153),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 12, left: 8),
                                      child: UpText(
                                        "Body Type",
                                        style: UpStyle(
                                            textSize: 18,
                                            textWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SearchByBodyWidget(
                                      collection: collection ?? 0,
                                      productOptionValues: productOptionValues,
                                    ),
                                  ],
                                ),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            width: 400,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            child: const SearchWidget(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
