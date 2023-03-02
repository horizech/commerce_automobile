import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/enums/up_button_type.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:shop/services/variation.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:shop/models/product_option_value.dart';
import 'package:shop/models/product_options.dart';
import 'package:shop/widgets/filters/variation_view.dart';
import 'package:shop/widgets/store/store_cubit.dart';
import 'package:shop/widgets/variations/variation_controller.dart';

class FilterPage extends StatelessWidget {
  final int? collection;
  final Function? change;
  const FilterPage({
    Key? key,
    this.collection,
    this.change,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<ProductOptionValue> sizeVariations;
    List<ProductOptionValue> colorVariations;
    List<ProductOptionValue> otherVariations = [];

    return BlocConsumer<StoreCubit, StoreState>(
      listener: (context, state) {},
      builder: (context, state) {
        List<ProductOption> productOptions = [];
        if (state.productOptions != null && state.productOptions!.isNotEmpty) {
          productOptions = state.productOptions!.toList();
        }
        if (state.productOptionValues != null &&
            state.productOptionValues!.isNotEmpty) {
          // sizeVariations = state.productOptionValues!
          //     .where(
          //       (c) =>
          //           c.collection == collection &&
          //           c.productOption ==
          //               state.productOptions!
          //                   .where(
          //                     (element) => element.name.toLowerCase() == 'size',
          //                   )
          //                   .first
          //                   .id,
          //     )
          //     .toList();
          // colorVariations = state.productOptionValues!
          //     .where(
          //       (c) =>
          //           c.collection == collection &&
          //           c.productOption ==
          //               state.productOptions?
          //                   .where(
          //                     (element) =>
          //                         element.name.toLowerCase() == 'color',
          //                   )
          //                   .first
          //                   .id,
          //     )
          //     .toList();
          otherVariations = state.productOptionValues!
              .where(
                (c) => c.collection == collection,
              )
              .toList();
        }

        return VariationFilter(
          otherVariations: otherVariations,
          productOptions: productOptions,
          change: change,
        );
        // Visibility(
        //   visible: (sizeVariations != [] && sizeVariations.isNotEmpty) ||
        //       (colorVariations != [] && colorVariations.isNotEmpty),
        //   child: Column(
        //     children: [
        //       VariationFilter(
        //         change: change,
        //         sizeVariations: sizeVariations,
        //         colorVariations: colorVariations,
        //       ),
        //     ],
        //   ),
        // );
      },
    );
  }
}

class VariationFilter extends StatefulWidget {
  // int? category;
  final List<ProductOptionValue>? sizeVariations;
  final List<ProductOptionValue>? colorVariations;
  final List<ProductOptionValue>? otherVariations;
  final List<ProductOption>? productOptions;
  final Function? change;
  const VariationFilter({
    Key? key,
    this.sizeVariations,
    this.colorVariations,
    this.otherVariations,
    this.productOptions,
    this.change,
  }) : super(key: key);

  @override
  State<VariationFilter> createState() => _VariationFilterState();
}

class _VariationFilterState extends State<VariationFilter> {
  Map<String, List<int>> selectedVariationsValues = {};
  Map<int, VariationController> variationControllers = {};
  Map<String, List<int>> oldVariations = {};

  onVariationChange(String key, List<int> values) {
    debugPrint("you clicked on $values for $key");

    selectedVariationsValues[key] = values;
    if (selectedVariationsValues[key]!.isEmpty) {
      selectedVariationsValues.remove(key);
    }
  }

  onChange() {
    widget.change!(selectedVariationsValues);
  }

  onReset() {
    setState(() {
      ServiceManager<VariationService>().removeVariation();
    });

    variationControllers.values
        .toList()
        .forEach((controller) => controller.reset!());
    setState(() {
      selectedVariationsValues.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    // if (variationControllers.isEmpty) {
    //   for (var element in VariationTypes.values) {
    //     variationControllers[element.index] = VariationController();
    //   }
    // }

    // if (selectedVariationsValues.isEmpty) {
    //   for (var element in VariationTypes.values) {
    //     selectedVariationsValues[element.index] = [];
    //   }
    // }

    return Wrap(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Wrap(children: [
            //   widget.sizeVariations != null && widget.sizeVariations!.isNotEmpty
            //       ? const Text("Sizes : ")
            //       : const Text(""),
            //   SizeVariationWidget(
            //     sizeVariations: widget.sizeVariations,
            //     onChange: (s) =>
            //         onVariationChange(VariationTypes.size.index, s),
            //     mode: VariationSelectionMode.filter,
            //     controller: variationControllers[VariationTypes.size.index],
            //   ),
            // ]),
            // Wrap(children: [
            //   widget.colorVariations != null &&
            //           widget.colorVariations!.isNotEmpty
            //       ? const Text("Colors : ")
            //       : const Text(""),
            //   ColorVariationWidget(
            //     colorVariations: widget.colorVariations,
            //     onChange: (c) =>
            //         onVariationChange(VariationTypes.color.index, c),
            //     mode: VariationSelectionMode.filter,
            //     controller: variationControllers[VariationTypes.color.index],
            //   ),
            // ]),
            // VariationViewWidget(
            //   productOptions: widget.productOptions,
            //   otherVariations: widget.otherVariations,
            //   change: (key, values) => onVariationChange(key, values),
            // ),
            ...widget.productOptions?.map(
                  (element) {
                    if (widget.otherVariations!
                        .any((v) => v.productOption == element.id)) {
                      return VariationViewWidget(
                        productOption: element,
                        otherVariations: widget.otherVariations,
                        change: (values) =>
                            onVariationChange(element.name, values),
                      );
                    } else {
                      return Container();
                    }
                  },
                ).toList() ??
                [],

            // GestureDetector(
            //   onTap: onReset,
            //   child: Wrap(
            //     crossAxisAlignment: WrapCrossAlignment.center,
            //     runAlignment: WrapAlignment.center,
            //     children: [
            //       const Padding(padding: EdgeInsets.all(10.0)),
            //       const Icon(
            //         Icons.delete_outline,
            //         size: 30,
            //       ),
            //       Text(
            //         "Clear Filters",
            //         style: Theme.of(context)
            //             .textTheme
            //             .headline2!
            //             .copyWith(fontSize: 16),
            //       ),
            //     ],
            //   ),
            // ),
            // ElevatedButton(onPressed: onReset, child: const Text("remove filter")),
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
              child: Center(
                child: UpButton(
                  icon: Icons.delete,
                  style: UpStyle(
                      buttonTextSize: 16,
                      buttonHoverBorderColor:
                          UpConfig.of(context).theme.primaryColor,
                      buttonHoverBackgroundColor:
                          UpConfig.of(context).theme.primaryColor.shade300,
                      buttonWidth: 250,
                      buttonBorderColor:
                          UpConfig.of(context).theme.secondaryColor),
                  onPressed: onReset,
                  text: "Clear Filters",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: UpButton(
                  icon: Icons.photo_filter_rounded,
                  style: UpStyle(
                    buttonTextSize: 16,
                    buttonHoverBorderColor:
                        UpConfig.of(context).theme.primaryColor,
                    buttonHoverBackgroundColor:
                        UpConfig.of(context).theme.primaryColor.shade300,
                    buttonWidth: 250,
                    buttonBackgroundColor:
                        UpConfig.of(context).theme.primaryColor,
                    buttonBorderColor:
                        UpConfig.of(context).theme.secondaryColor,
                  ),
                  onPressed: onChange,
                  text: "Apply Filters",
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}



// class VariationFilter extends StatefulWidget {
//   int? category;
//   // List<Variation> variations;
//   Function? change;
//   VariationFilter(
//       {Key? key,
//       required this.category,
//       //  required this.variations,
//       this.change})
//       : super(key: key);

//   @override
//   State<VariationFilter> createState() => _VariationFilterState();
// }

// class _VariationFilterState extends State<VariationFilter> {
//   Map<int, List<String>> selectedVariationsValues = {};
//   Map<int, VariationController> variationControllers = {};

//   onVariationChange(int key, List<String> values) {
//     debugPrint("you clicked on $values for $key");
//     setState(() {
//       selectedVariationsValues[key] = values;
//     });
//   }

//   onChange() {
//     widget.change!(selectedVariationsValues);
//   }

//   onReset() {
//     variationControllers.values
//         .toList()
//         .forEach((controller) => controller.reset!());
//     setState(() {
//       selectedVariationsValues.clear();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // if (variationControllers.isEmpty) {
//     //   for (var x in widget.category.variations) {
//     //     variationControllers[x] = VariationController();
//     //   }
//     // }
//     // if (selectedVariationsValues.isEmpty) {
//     //   for (var variationId in widget.category.variations) {
//     //     selectedVariationsValues[variationId] = [];
//     //   }
//     // }
//     return Wrap(
//       children: [
//         Column(
//           children: [
//             //    widget.category.variations
//             //       .map(
//             //         (variationId) => VariationSelector(
//             //           variation: widget.variations
//             //               .where((element) => element.id == variationId)
//             //               .first,
//             //           onChange: (s) => onVariationChange(variationId, s),
//             //           maxSelectCount: -1,
//             //           controller: variationControllers[variationId],
//             //         ),
//             //       )
//             //       .toList(),
//             // ),
//                  SizeVariationWidget(
//           // variation: variation,
//           onChange: onChange,
//           // selectedValues: selectedVariationsValues.keys.contains(variation.id)
//           //     ? selectedVariationsValues[variation.id]
//           //     : null,
//           maxSelectCount: -1,
//           // controller: controller,
//         ),
//             GestureDetector(
//               onTap: onReset,
//               child: Wrap(
//                 crossAxisAlignment: WrapCrossAlignment.center,
//                 runAlignment: WrapAlignment.center,
//                 children: [
//                   const Padding(padding: EdgeInsets.all(10.0)),
//                   Container(
//                     child: const Icon(
//                       Icons.delete_outline,
//                       size: 30,
//                     ),
//                   ),
//                   Container(
//                     child: Text(
//                       "Clear Filters",
//                       style: Theme.of(context)
//                           .textTheme
//                           .headline2!
//                           .copyWith(fontSize: 16),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // ElevatedButton(onPressed: onReset, child: const Text("remove filter")),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: ElevatedButton(
//                   onPressed: onChange, child: const Text("Apply Filter")),
//             ),
//           ],
// )
//       ],
//     );
//   }
// }
