import 'package:flutter_up/models/up_label_value.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/services/up_navigation.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_dropdown.dart';
import 'package:shop/models/product_option_value.dart';
import 'package:shop/widgets/store/store_cubit.dart';
import 'package:shop/services/variation.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({
    super.key,
  });

  gotoMakeModel(id) {
    Map<String, List<int>> selectedVariationsValues = {
      "Manufacturer": [id]
    };
    ServiceManager<VariationService>().setVariation(selectedVariationsValues);
  }

  @override
  Widget build(BuildContext context) {
    int collection = 0;
    List<ProductOptionValue> productOptionsValues = [];
    List<ProductOptionValue> productOptionsValuesMod = [];
    int? productOptionId;
    int? productOptionIdMod;
    String makeDropDownValue = "";
    String modelDropDownValue = "";
    List<UpLabelValuePair> dropDownMake = [];
    List<UpLabelValuePair> dropDownModel = [];

    return BlocConsumer<StoreCubit, StoreState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state.collections != null && state.collections!.isNotEmpty) {
            collection = state.collections!
                .where((element) => element.name == "Used Cars")
                .first
                .id!;
          }
          if (state.productOptions != null &&
              state.productOptions!.isNotEmpty) {
            productOptionId = state.productOptions!
                .where((element) => element.name == "Manufacturer")
                .first
                .id;
          }
          if (state.productOptionValues != null &&
              state.productOptionValues!.isNotEmpty) {
            productOptionsValues = state.productOptionValues!
                .where((element) => element.productOption == productOptionId)
                .toList();
            if (dropDownMake.isEmpty) {
              for (var element in productOptionsValues) {
                dropDownMake.add(UpLabelValuePair(
                    label: element.name, value: "${element.id}"));
              }
            }
          }

          if (state.productOptions != null &&
              state.productOptions!.isNotEmpty) {
            productOptionIdMod = state.productOptions!
                .where((element) => element.name == "Model")
                .first
                .id;
          }
          if (state.productOptionValues != null &&
              state.productOptionValues!.isNotEmpty) {
            productOptionsValuesMod = state.productOptionValues!
                .where((element) => element.productOption == productOptionIdMod)
                .toList();
            if (dropDownModel.isEmpty) {
              for (var element in productOptionsValues) {
                dropDownModel.add(UpLabelValuePair(
                    label: element.name, value: "${element.id}"));
              }
            }
          }

          return Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: UpConfig.of(context).theme.primaryColor, width: 4),
              borderRadius: BorderRadius.circular(4),
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
                        style:
                            UpStyle(textSize: 18, textWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 52, vertical: 4),
                  child: Visibility(
                    visible: dropDownMake.isNotEmpty,
                    child: UpDropDown(
                      itemList: dropDownMake,
                      label: "Make",
                      value: makeDropDownValue,
                      onChanged: ((value) {
                        makeDropDownValue = value ?? "";
                      }),
                      style: UpStyle(dropdownFilledColor: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 52, vertical: 4),
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
                      if (makeDropDownValue.isNotEmpty) {
                        gotoMakeModel(int.parse(makeDropDownValue));
                      }

                      ServiceManager<UpNavigationService>()
                          .navigateToNamed(Routes.products, queryParams: {
                        "collection": '$collection',
                      });
                    },
                    style: UpStyle(buttonWidth: 100),
                    text: "Search",
                  ),
                )
              ],
            ),
          );
        });
  }
}
