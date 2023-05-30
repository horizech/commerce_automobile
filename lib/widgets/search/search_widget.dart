import 'package:flutter_up/models/up_label_value.dart';
import 'package:flutter_up/services/up_navigation.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_dropdown.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/attribute_value.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_attribute.dart';
import 'package:shop/services/product_service.dart';
import 'package:shop/widgets/store/store_cubit.dart';
import 'package:shop/services/variation.dart';

class SearchWidget extends StatefulWidget {
  final int collection;
  const SearchWidget({
    super.key,
    required this.collection,
  });

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  int? manufacturerAttributeId;
  int? modelAttributeId;
  String makeDropDownValue = "";
  List<AttributeValue> manufacturerAttributeValues = [];
  String modelDropDownValue = "";
  List<UpLabelValuePair> dropDownManufacturer = [];
  List<UpLabelValuePair> dropDownModel = [];
  bool isLoad = false;
  List<AttributeValue> attributesValues = [];
  List<ProductAttribute> productAttributes = [];

  List<Product> products = [];
  @override
  void initState() {
    super.initState();
    getProducts();
  }

  gotoMakeModel(id) {
    if (modelAttributeId != null) {
      Map<String, List<int>> selectedVariationsValues = {
        "$modelAttributeId": [id]
      };
      ServiceManager<VariationService>().setVariation(selectedVariationsValues);
    }
  }

  gotoMake(id) {
    if (manufacturerAttributeId != null) {
      Map<String, List<int>> selectedVariationsValues = {
        "$manufacturerAttributeId": [id]
      };
      ServiceManager<VariationService>().setVariation(selectedVariationsValues);
    }
  }

  getProducts() async {
    products = await ProductService.getProducts(
        [widget.collection], {}, null, null, {});
    if (products.isNotEmpty) {
      setState(() {});
    }
  }

  generateModelDropdown() {
    dropDownModel.clear();
    List<int> modelIds = [];
    if (products.isNotEmpty) {
      List<Product> filteredProducts = products
          .where((element) =>
              element.options != null &&
              element.options!.isNotEmpty &&
              element.options!.containsKey("$manufacturerAttributeId") &&
              element.options!["$manufacturerAttributeId"] ==
                  int.parse(makeDropDownValue))
          .toList();
      if (filteredProducts.isNotEmpty) {
        for (var product in filteredProducts) {
          if (product.options != null &&
              product.options!.isNotEmpty &&
              product.options!.entries.any((entry) =>
                  entry.value != null && entry.key == "$modelAttributeId")) {
            modelIds.add(product.options!["$modelAttributeId"]);
          }
        }
      }
      modelIds = modelIds.toSet().toList();
      if (modelIds.isNotEmpty) {
        for (var id in modelIds) {
          if (attributesValues.any((element) => element.id == id)) {
            dropDownModel.add(UpLabelValuePair(
                label: attributesValues
                    .where((element) => element.id == id)
                    .first
                    .name,
                value:
                    "${attributesValues.where((element) => element.id == id).first.id}"));
          }
          setState(() {});
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreCubit, StoreState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state.attributes != null && state.attributes!.isNotEmpty) {
            manufacturerAttributeId = state.attributes!
                .where((element) => element.name == "Manufacturer")
                .first
                .id;
          }
          if (manufacturerAttributeValues.isEmpty) {
            if (state.attributeValues != null &&
                state.attributeValues!.isNotEmpty) {
              manufacturerAttributeValues = state.attributeValues!
                  .where(
                      (element) => element.attribute == manufacturerAttributeId)
                  .toList();
              if (dropDownManufacturer.isEmpty) {
                for (var element in manufacturerAttributeValues) {
                  dropDownManufacturer.add(UpLabelValuePair(
                      label: element.name, value: "${element.id}"));
                }
              }
            }
          }

          if (state.attributes != null && state.attributes!.isNotEmpty) {
            modelAttributeId = state.attributes!
                .where((element) => element.name == "Model")
                .first
                .id;
          }
          if (state.attributeValues != null &&
              state.attributeValues!.isNotEmpty) {
            attributesValues = state.attributeValues!;
          }
          if (state.productAttributes != null &&
              state.productAttributes!.isNotEmpty) {
            productAttributes = state.productAttributes!;
          }

          return products.isNotEmpty
              ? Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: UpConfig.of(context).theme.primaryColor,
                        width: 2),
                    borderRadius: BorderRadius.circular(12),
                    color: const Color.fromARGB(64, 249, 153, 153),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 12, 0, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search,
                              color: UpConfig.of(context).theme.primaryColor,
                              size: 30,
                            ),
                            UpText(
                              "Make/Model Seach",
                              style: UpStyle(
                                  textSize: 18, textWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 52, vertical: 4),
                        child: Visibility(
                          visible: dropDownManufacturer.isNotEmpty,
                          child: UpDropDown(
                            itemList: dropDownManufacturer,
                            label: "Make",
                            value: makeDropDownValue,
                            onChanged: ((value) {
                              makeDropDownValue = value ?? "";
                              generateModelDropdown();
                            }),
                            style: UpStyle(dropdownFilledColor: Colors.white),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 52, vertical: 4),
                        child: Visibility(
                          visible: dropDownModel.isEmpty,
                          child: UpDropDown(
                            itemList: const [],
                            value: modelDropDownValue,
                            label: "Model",
                            onChanged: ((value) {
                              modelDropDownValue = value ?? "";
                            }),
                            style: UpStyle(dropdownFilledColor: Colors.white),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 52, vertical: 4),
                        child: Visibility(
                          visible: dropDownModel.isNotEmpty,
                          child: UpDropDown(
                            itemList: dropDownModel,
                            value: modelDropDownValue,
                            label: "Model",
                            onChanged: ((value) {
                              modelDropDownValue = value ?? "";
                            }),
                            style: UpStyle(dropdownFilledColor: Colors.white),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                        child: UpButton(
                          onPressed: () {
                            if (modelDropDownValue.isNotEmpty) {
                              gotoMakeModel(int.parse(modelDropDownValue));
                            } else if (makeDropDownValue.isNotEmpty &&
                                modelDropDownValue.isEmpty) {
                              gotoMake(int.parse(makeDropDownValue));
                            }

                            ServiceManager<UpNavigationService>()
                                .navigateToNamed(Routes.products, queryParams: {
                              "collection": '${widget.collection}',
                            });
                          },
                          style: UpStyle(buttonWidth: 100),
                          text: "Search",
                        ),
                      )
                    ],
                  ),
                )
              : const SizedBox();
        });
  }
}
