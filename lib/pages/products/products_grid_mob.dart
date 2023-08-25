import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/enums/up_button_type.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_scaffold.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/models/product.dart';
import 'package:shop/services/variation.dart';
import 'package:shop/widgets/appbar/automobile_appbar.dart';
import 'package:shop/widgets/drawer/menu_drawer.dart';
import 'package:shop/widgets/error/error.dart';
import 'package:shop/widgets/filters/filter.dart';
import 'package:shop/widgets/products/products_grid.dart';
import 'package:shop/services/product_service.dart';
import 'package:shop/widgets/store/store_cubit.dart';

import '../../widgets/products/goto_top_button.dart';
import '../../widgets/products/scroll_to_top_service.dart';

class ProductsGridPageMob extends StatefulWidget {
  final Map<String, String>? queryParams;

  const ProductsGridPageMob({
    this.queryParams,
    Key? key,
  }) : super(key: key);

  @override
  State<ProductsGridPageMob> createState() => _AllProductsState();
}

class _AllProductsState extends State<ProductsGridPageMob> {
  late ScrollController scrollController =
      ScrollController(initialScrollOffset: 50);
  int? selectedKeywordId = 0;
  double offset = 0;
  Map<String, List<int>> selectedVariationsValues = {};
  List<Product>? filteredProducts;
  List<Product>? products;
  bool showBackToTopButton = false;
  @override
  void initState() {
    scrollController = ScrollController()
      ..addListener(() {
        if (!scrollController.hasClients || scrollController.offset < 1) {
          ServiceManager<ScrollToTopService>().updateOffset(0);
        } else {
          ServiceManager<ScrollToTopService>()
              .updateOffset(scrollController.offset);
        }
      });
    ServiceManager<ScrollToTopService>().goUpStream$.listen((event) {
      scrollToTop();
    });
    super.initState();
  }

  // void _onScroll() {
  //   offset = scrollController.offset;
  // }

  void scrollToTop() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(0,
          duration: const Duration(seconds: 1), curve: Curves.linear);
    });
  }
  // @override
  // void dispose() {
  //   scrollController.dispose(); // dispose the controller
  //   super.dispose();
  // }

  // void scrollToTop() {
  //   scrollController.animateTo(0,
  //       duration: const Duration(seconds: 1), curve: Curves.linear);
  // }

  change(int? id, Map<String, List<int>>? s) {
    selectedVariationsValues = {};
    selectedKeywordId = id;
    selectedVariationsValues = s ?? {};

    ServiceManager<VariationService>().setVariation(s ?? {});
  }

  List<int> _getCollectionsByParent(
    StoreState state,
    int parent,
    List<int> collections,
  ) {
    collections.add(parent);
    if (state.collections != null &&
        state.collections!.any(
          (element) => element.parent == parent,
        )) {
      state.collections!
          .where((element) => element.parent == parent)
          .forEach((child) {
        collections = _getCollectionsByParent(state, child.id!, collections);
      });
    }

    return collections;
  }

  @override
  Widget build(BuildContext context) {
    List<int> collections = [];
    bool isCollectionFilter = false;

    int? collection;

    widget.queryParams;
    if (widget.queryParams!['collection'] != null &&
        widget.queryParams!['collection']!.isNotEmpty) {
      collection = int.parse(widget.queryParams!['collection'] ?? "");
      isCollectionFilter = true;
    } else {
      if (widget.queryParams != null && widget.queryParams!.isNotEmpty) {
        isCollectionFilter = false;
      } else {
        isCollectionFilter = true;
      }
    }

    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return UpScaffold(
        scaffoldKey: scaffoldKey,
        drawer: const MenuDrawer(),
        endDrawer: SafeArea(
          child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Drawer(
              child: SizedBox(
                child: FilterPage(
                  collection: collection!,
                  change: (v) => change(0, v),
                ),
              ),
            );
          }),
        ),
        body: Column(
          children: [
            AutomobileAppbar(
              scaffoldKey: scaffoldKey,
            ),
            Expanded(
              child: isCollectionFilter
                  ? BlocConsumer<StoreCubit, StoreState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        collections = [];
                        if (collection != null) {
                          int parent = collection;
                          collections =
                              _getCollectionsByParent(state, parent, []);
                        }
                        return Column(
                          children: [
                            StreamBuilder(
                              stream: ServiceManager<VariationService>()
                                  .variationStream$,
                              builder: (BuildContext context,
                                  storedVariationsValues) {
                                return FutureBuilder<List<Product>>(
                                  future: ProductService.getProducts(
                                      collections,
                                      storedVariationsValues.data ?? {},
                                      selectedKeywordId,
                                      "", {}),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<Product>> snapshot) {
                                    products = snapshot.data;
                                    // filteredProducts ??= products;

                                    if (snapshot.connectionState !=
                                        ConnectionState.done) {
                                      return Center(
                                        child: SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height -
                                              100,
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  "automobilelogo.png",
                                                  height: 100,
                                                  width: 150,
                                                ),
                                                const UpText("Loading...")
                                              ]),
                                        ),
                                      );
                                    }
                                    return snapshot.hasData
                                        ? Expanded(
                                            child: Stack(children: [
                                              SingleChildScrollView(
                                                controller: scrollController,
                                                scrollDirection: Axis.vertical,
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 50),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        ProductsGrid(
                                                          // products: filteredProducts!,
                                                          collection:
                                                              collection,
                                                          products:
                                                              snapshot.data!,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 24.0,
                                                              right: 20),
                                                      child: SizedBox(
                                                        width: 50,
                                                        child: UpButton(
                                                          style: UpStyle(
                                                              buttonBorderRadius:
                                                                  26,
                                                              buttonBorderColor:
                                                                  Colors
                                                                      .transparent),
                                                          onPressed: () {
                                                            showDialog(
                                                              context: context,
                                                              barrierDismissible:
                                                                  true,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  backgroundColor:
                                                                      UpConfig.of(
                                                                              context)
                                                                          .theme
                                                                          .baseColor,
                                                                  content:
                                                                      SingleChildScrollView(
                                                                    scrollDirection:
                                                                        Axis.vertical,
                                                                    child:
                                                                        SizedBox(
                                                                      child:
                                                                          FilterPage(
                                                                        collection:
                                                                            collection!,
                                                                        change: (v) => change(
                                                                            0,
                                                                            v),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          },
                                                          type: UpButtonType
                                                              .elevated,
                                                          icon: Icons.tune,
                                                        ),
                                                      ),
                                                    ),
                                                  ]),
                                            ]),
                                          )
                                        : const CircularProgressIndicator();
                                  },
                                );
                              },
                            ),
                          ],
                        );
                      })
                  : const NotFoundErrorWidget(),
            ),
          ],
        ),
        floatingActionButton: GestureDetector(
          onTap: () {
            scrollToTop();
          },
          child: const GoToTopButtonWidget(),
        )

        //  showBackToTopButton == false
        //     ? null
        //     :
        //   FloatingActionButton(
        // backgroundColor: UpConfig.of(context).theme.primaryColor,
        // onPressed: scrollToTop,
        // child: const Icon(Icons.arrow_upward),
        );
  }
}
