import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/widgets/up_card.dart';
import 'package:shop/models/attribute.dart';
import 'package:shop/models/attribute_value.dart';
import 'package:shop/services/attribute_service.dart';
import 'package:shop/services/variation.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:shop/widgets/filters/variation_view.dart';
import 'package:shop/widgets/store/store_cubit.dart';
import 'package:shop/widgets/variations/variation_controller.dart';

class FilterPage extends StatefulWidget {
  final int collection;
  final Function? change;
  const FilterPage({
    Key? key,
    required this.collection,
    this.change,
  }) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  List<Attribute> attributes = [];
  List<AttributeValue> attributeValues = [];
  List<dynamic> attributeValueList = [];
  @override
  void initState() {
    super.initState();
    getFilters();
  }

  getFilters() async {
    attributeValueList = await AttributeService.getAttributeValuesByCollection(
        widget.collection);

    if (attributeValueList.isNotEmpty) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreCubit, StoreState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (attributes.isEmpty) {
          if (state.attributes != null && state.attributes!.isNotEmpty) {
            attributes = state.attributes!.toList();
          }
        }
        if (attributeValues.isEmpty) {
          if (attributeValueList.isNotEmpty) {
            List<AttributeValue> aValues = [];
            if (state.attributeValues != null &&
                state.attributeValues!.isNotEmpty) {
              aValues = state.attributeValues!.toList();
            }
            if (attributeValueList.isNotEmpty) {
              for (var list in attributeValueList) {
                if (aValues
                    .any((element) => element.id == list["AttributeValues"])) {
                  attributeValues.add(aValues
                      .where((element) => element.id == list["AttributeValues"])
                      .first);
                }
              }
            }
          }
        }

        return attributeValues.isNotEmpty
            ? VariationFilter(
                attributes: attributes,
                attributeValues: attributeValues,
                change: widget.change,
              )
            : const SizedBox();
      },
    );
  }
}

class VariationFilter extends StatefulWidget {
  final List<AttributeValue>? attributeValues;
  final List<Attribute>? attributes;
  final Function? change;
  const VariationFilter({
    Key? key,
    this.attributes,
    this.attributeValues,
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
    if (MediaQuery.of(context).size.width <= 600) {
      Navigator.pop(context);
    }

    // if (defaultTargetPlatform == TargetPlatform.android) {
    //   Navigator.pop(context);
    // }
  }

  onReset() {
    setState(() {
      ServiceManager<VariationService>().removeVariation();
      if (MediaQuery.of(context).size.width <= 600) {
        Navigator.pop(context);
      }
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
            ...widget.attributes?.map(
                  (element) {
                    if (widget.attributeValues!
                        .any((v) => v.attribute == element.id)) {
                      return VariationViewWidget(
                        attribute: element,
                        attributeValues: widget.attributeValues,
                        change: (values) =>
                            onVariationChange(element.id.toString(), values),
                      );
                    } else {
                      return Container();
                    }
                  },
                ).toList() ??
                [],
            UpCard(
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                    child: Center(
                      child: UpButton(
                        icon: Icons.delete,
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
                        onPressed: onChange,
                        text: "Apply Filters",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
