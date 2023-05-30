import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_circualar_progress.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/models/attribute.dart';
import 'package:shop/models/attribute_value.dart';
import 'package:shop/services/attribute_service.dart';
import 'package:shop/widgets/appbar/automobile_appbar.dart';
import 'package:shop/widgets/drawer/menu_drawer.dart';
import 'package:shop/widgets/footer/automobile_footer.dart';
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
  List<Attribute> attributes = [];
  List<AttributeValue> attributeValues = [];
  List<AttributeValue> bodyTypeAttributeValues = [];
  List<dynamic> attributeValueList = [];
  int? bodyTypeAttribute;

  getFilters(List<AttributeValue> attributeValues1) async {
    if (collection != null && bodyTypeAttribute != null) {
      attributeValueList =
          await AttributeService.getAttributeValuesByCollection(collection!);
      if (attributeValueList.isNotEmpty) {
        for (var list in attributeValueList) {
          if (attributeValues1.any((element) =>
              element.id == list["AttributeValues"] &&
              element.attribute == bodyTypeAttribute)) {
            bodyTypeAttributeValues.add(attributeValues1
                .where((element) =>
                    element.id == list["AttributeValues"] &&
                    element.attribute == bodyTypeAttribute)
                .first);
          }
          setState(() {});
        }
      }
    }
  }

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
        // bottomNavigationBar: const FooterWidget(),
        drawerEnableOpenDragGesture: false,
        endDrawerEnableOpenDragGesture: false,
        body: Column(
          children: [
            Container(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height - 30),
              child: BlocConsumer<StoreCubit, StoreState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state.collections != null &&
                      state.collections!.isNotEmpty) {
                    collection = state.collections!
                        .where((element) => element.name == "Used Cars")
                        .first
                        .id;
                  }

                  if (bodyTypeAttributeValues.isEmpty) {
                    if (state.attributes != null &&
                        state.attributes!.isNotEmpty) {
                      bodyTypeAttribute = state.attributes!
                          .where((element) => element.name == "Body Type")
                          .first
                          .id;

                      if (state.attributeValues != null &&
                          state.attributeValues!.isNotEmpty &&
                          bodyTypeAttribute != null) {
                        getFilters(state.attributeValues ?? []);
                      }
                    }
                  }
                  return bodyTypeAttributeValues.isNotEmpty
                      ? Column(
                          children: [
                            AutomobileAppbar(
                              scaffoldKey: scaffoldKey,
                            ),
                            bodyTypeAttributeValues.isNotEmpty &&
                                    collection != null &&
                                    bodyTypeAttribute != null
                                ? Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Column(
                                        children: [
                                          Container(),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 24),
                                            child: Container(
                                                // decoration: BoxDecoration(
                                                //     border: Border.all(
                                                //       color:
                                                //           UpConfig.of(context)
                                                //               .theme
                                                //               .primaryColor,
                                                //       width: 4,
                                                //     ),
                                                //     color: const Color.fromARGB(
                                                //         64, 249, 153, 153),
                                                //     borderRadius:
                                                //         BorderRadius.circular(
                                                //             8)),
                                                child: Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 12,
                                                            left: 8),
                                                    child: UpText(
                                                      "Body Type",
                                                      style: UpStyle(
                                                          textSize: 18,
                                                          textWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  SearchByBodyWidget(
                                                      collection: collection!,
                                                      attributeValues:
                                                          bodyTypeAttributeValues,
                                                      bodyTypeAttribute:
                                                          bodyTypeAttribute!)
                                                ],
                                              ),
                                            )),
                                          ),
                                          collection != null
                                              ? Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: Container(
                                                    width: 400,
                                                    decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.5),
                                                          spreadRadius: 5,
                                                          blurRadius: 7,
                                                          offset: Offset(0,
                                                              3), // changes position of shadow
                                                        ),
                                                      ],
                                                      color: Colors.white,
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(12),
                                                      ),
                                                    ),
                                                    child: SearchWidget(
                                                      collection: collection!,
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox(),
                                        ],
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        )
                      : const UpCircularProgress();
                },
              ),
            ),
            const FooterWidget(),
          ],
        ),
      ),
    );
  }
}
