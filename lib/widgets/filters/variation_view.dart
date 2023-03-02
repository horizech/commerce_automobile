import 'package:flutter/material.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_checkbox.dart';
import 'package:flutter_up/widgets/up_expansion_tile.dart';
import 'package:shop/models/product_option_value.dart';
import 'package:shop/models/product_options.dart';

class VariationViewWidget extends StatefulWidget {
  final List<ProductOptionValue>? otherVariations;
  final ProductOption productOption;
  final Function? change;

  const VariationViewWidget({
    Key? key,
    this.otherVariations,
    required this.productOption,
    this.change,
  }) : super(key: key);

  @override
  State<VariationViewWidget> createState() => _VariationViewWidgetState();
}

class _VariationViewWidgetState extends State<VariationViewWidget> {
  Map<String, List<int>?>? selectedVariations = {};
  List<int> selectedValues = [];
  List<bool> checkboxesValues = [];
  int totalLength = 0;

  onChange(int id, bool newCheck, int key) {
    if (newCheck) {
      selectedValues.add(id);
    } else {
      selectedValues.remove(id);
    }
    if (widget.change != null) {
      widget.change!(selectedValues);
    }
    setState(() {
      checkboxesValues[key] = newCheck;
    });
  }

  @override
  void initState() {
    super.initState();
    if (checkboxesValues.isEmpty) {
      totalLength = widget.otherVariations!.length;
      for (int i = 0; i < totalLength; i++) {
        checkboxesValues.add(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return checkboxesValues.isNotEmpty && checkboxesValues.length == totalLength
        ? UpExpansionTile(
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            expandedAlignment: Alignment.topLeft,
            childrenPadding: const EdgeInsets.all(8),
            title: widget.productOption.name,
            style: UpStyle(
              textSize: 16,
              textWeight: FontWeight.bold,
              textColor: UpConfig.of(context).theme.primaryColor,
              expansionTileCollapsedIconColor:
                  UpConfig.of(context).theme.primaryColor,
              expansionTileIconColor: UpConfig.of(context).theme.primaryColor,
            ),
            children: widget.otherVariations!
                .asMap()
                .entries
                .where((e) => e.value.productOption == widget.productOption.id)
                .map(
                  (variation) => UpCheckbox(
                    label: variation.value.name,
                    style: UpStyle(
                      checkboxLabelSize: 15,
                      checkboxLabelColor:
                          UpConfig.of(context).theme.primaryColor,
                    ),
                    initialValue: checkboxesValues[variation.key],
                    onChange: (newCheck) =>
                        onChange(variation.value.id!, newCheck, variation.key),
                  ),
                )
                .toList(),
          )
        : const SizedBox();
  }
}
