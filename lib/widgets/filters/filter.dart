import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/config/up_config.dart';
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
    return Wrap(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
