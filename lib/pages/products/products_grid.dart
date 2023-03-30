import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/config/up_config.dart';
// import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/widgets/up_orientational_column_row.dart';
import 'package:shop/models/product.dart';
import 'package:shop/services/variation.dart';
import 'package:shop/widgets/appbar/automobile_appbar.dart';
import 'package:shop/widgets/drawer/MenuDrawer.dart';
import 'package:shop/widgets/error/error.dart';
import 'package:shop/widgets/filters/filter.dart';
import 'package:shop/widgets/products/products_grid.dart';
import 'package:shop/services/product_service.dart';
import 'package:shop/widgets/store/store_cubit.dart';

class ProductsGridPage extends StatefulWidget {
  final Map<String, String>? queryParams;
  const ProductsGridPage({
    this.queryParams,
    Key? key,
  }) : super(key: key);

  @override
  State<ProductsGridPage> createState() => _AllProductsState();
}

class _AllProductsState extends State<ProductsGridPage> {
  int? selectedKeywordId = 0;
  Map<String, List<int>> selectedVariationsValues = {};
  List<Product>? filteredProducts;
  List<Product>? products;

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

    return Container(
      decoration: BoxDecoration(
        color: UpConfig.of(context).theme.secondaryColor,
        // image: DecorationImage(
        //   image: AssetImage("assets/car.jpg"),
        //   fit: BoxFit.fill,
        // ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        key: scaffoldKey,
        drawer: const MenuDrawer(),
        drawerEnableOpenDragGesture: false,
        endDrawerEnableOpenDragGesture: false,
        body: Column(
          children: [
            AutomobileAppbar(
              scaffoldKey: scaffoldKey,
            ),
            Expanded(
              child: isCollectionFilter
                  ? SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: BlocConsumer<StoreCubit, StoreState>(
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
                                // const HeaderWidget(),
                                UpOrientationalColumnRow(
                                  widths: const [300, 0],
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          right: BorderSide(
                                            color: UpConfig.of(context)
                                                .theme
                                                .primaryColor,
                                            width: 1,
                                          ),
                                          bottom: BorderSide(
                                            color: UpConfig.of(context)
                                                .theme
                                                .primaryColor,
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      // color: Colors.red[400],
                                      child: FilterPage(
                                        collection: collection!,
                                        change: (v) => change(0, v),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        StreamBuilder(
                                          stream:
                                              ServiceManager<VariationService>()
                                                  .variationStream$,
                                          builder: (BuildContext context,
                                              storedVariationsValues) {
                                            return FutureBuilder<List<Product>>(
                                              future:
                                                  ProductService.getProducts(
                                                      collections,
                                                      storedVariationsValues
                                                              .data ??
                                                          {},
                                                      selectedKeywordId,
                                                      "",
                                                      {}),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<List<Product>>
                                                      snapshot) {
                                                products = snapshot.data;
                                                // filteredProducts ??= products;

                                                if (snapshot.connectionState !=
                                                    ConnectionState.done) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            30.0),
                                                    child: GridView.builder(
                                                      gridDelegate:
                                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 2,
                                                      ),
                                                      itemCount: 3,
                                                      shrinkWrap: true,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(0),
                                                          child: SizedBox(
                                                            height: 300,
                                                            width: 300,
                                                            child: Container(
                                                                color: Colors
                                                                    .grey[200]),
                                                          ),
                                                        );
                                                      },

                                                      // itemCount: 6,
                                                    ),
                                                  );
                                                }
                                                return snapshot.hasData
                                                    ? ProductsGrid(
                                                        // products: filteredProducts!,
                                                        collection: collection,
                                                        products:
                                                            snapshot.data!,
                                                      )
                                                    : const CircularProgressIndicator();
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }),
                    )
                  : const NotFoundErrorWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
