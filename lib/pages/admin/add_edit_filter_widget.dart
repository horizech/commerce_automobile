import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/enums/text_style.dart';
import 'package:flutter_up/enums/up_button_type.dart';
import 'package:flutter_up/enums/up_color_type.dart';
import 'package:flutter_up/models/up_label_value.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_dropdown.dart';
import 'package:flutter_up/widgets/up_icon.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/dialogs/add_edit_attribute_dialog.dart';
import 'package:shop/dialogs/add_edit_attribute_value_dialog.dart';
import 'package:shop/models/attribute_value.dart';
import 'package:shop/models/attribute.dart';
import 'package:shop/services/add_edit_product_service/add_edit_product_service.dart';
import 'package:shop/widgets/store/store_cubit.dart';

class AddEditFiltersWidget extends StatefulWidget {
  Map<String, dynamic>? options;
  final Function onChange;
  AddEditFiltersWidget({
    Key? key,
    this.options,
    required this.onChange,
  }) : super(key: key);

  @override
  State<AddEditFiltersWidget> createState() => _AddEditFiltersWidgetState();
}

class _AddEditFiltersWidgetState extends State<AddEditFiltersWidget> {
  List<Attribute> attributes = [];
  List<AttributeValue> attributeValues = [];
  Map<String, dynamic> newOptions = {};

  _attributeValueAddDialog(Attribute attribute) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AddEditAttributeValueDialog(
          attribute: attribute,
        );
      },
    ).then((result) {
      if (result == "success") {
        _getAttributeValues();
      }
    });
  }

  _attributeAddDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AddEditAttributeDialog(
          attributes: attributes,
        );
      },
    ).then((result) {
      if (result == "success") {
        _getAttributes();
      }
    });
  }

  // by api
  _getAttributes() async {
    List<Attribute>? newAttributes =
        await AddEditProductService.getAttributes();

    if (newAttributes != null && newAttributes.isNotEmpty) {
      attributes = newAttributes;
      _getAttributeValues();
    } else {}
  }

  _getAttributeValues() async {
    attributeValues = await AddEditProductService.getAttributeValues() ?? [];
    if (attributeValues.isNotEmpty) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.options != null && widget.options!.isNotEmpty) {
      widget.options!.forEach((key, value) {
        newOptions[key] = value;
      });
    }
  }

  _addOptionsForProduct() async {
    widget.onChange(newOptions);
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
          if (state.attributeValues != null &&
              state.attributeValues!.isNotEmpty) {
            attributeValues = state.attributeValues!.toList();
          }
        }

        return attributes.isNotEmpty
            ? SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 5.0),
                          child: UpText(
                            "Attribute",
                            type: UpTextType.heading6,
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          height: 40,
                          child: UpButton(
                            onPressed: () {
                              _attributeAddDialog();
                            },
                            text: "Create",
                            icon: Icons.add,
                          ),
                        ),
                      ],
                    ),

                    // attribute values
                    attributes.isNotEmpty && attributeValues.isNotEmpty
                        ? Column(
                            children: attributes.map(
                              (element) {
                                if (attributeValues
                                    .any((v) => v.attribute == element.id)) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.8,
                                        child: AttributeDropdownWidget(
                                          attribute: element,
                                          attributeValues: attributeValues,
                                          change: (value) {
                                            newOptions["${element.id}"] =
                                                int.parse(value);
                                          },
                                          initialValue: widget.options !=
                                                      null &&
                                                  widget.options!.isNotEmpty &&
                                                  widget.options![
                                                          "${element.id}"] !=
                                                      null
                                              ? widget.options!["${element.id}"]
                                                  .toString()
                                              : null,
                                        ),
                                      ),
                                      UpButton(
                                        onPressed: () {
                                          _attributeValueAddDialog(element);
                                        },
                                        type: UpButtonType.icon,
                                        child: const UpIcon(icon: Icons.add),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ).toList(),
                          )
                        : const SizedBox(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 80,
                            child: UpButton(
                              onPressed: () {
                                _addOptionsForProduct();
                              },
                              text: "Save",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : const SizedBox();
      },
    );
  }
}

class AttributeDropdownWidget extends StatefulWidget {
  final List<AttributeValue>? attributeValues;
  final Attribute attribute;
  final Function? change;
  final String? initialValue;

  const AttributeDropdownWidget({
    Key? key,
    this.attributeValues,
    required this.attribute,
    this.initialValue,
    this.change,
  }) : super(key: key);

  @override
  State<AttributeDropdownWidget> createState() =>
      _AttributeDropdownWidgetState();
}

class _AttributeDropdownWidgetState extends State<AttributeDropdownWidget> {
  String currentOption = "";
  List<AttributeValue>? oldAttributeValues = [];
  List<UpLabelValuePair> attributeDropdown = [];
  String oldValue = "";
  @override
  void initState() {
    super.initState();
    initialize();
  }

  initialize() {
    widget.attributeValues!
        .where((e) => e.attribute == widget.attribute.id)
        .forEach((element) {
      attributeDropdown
          .add(UpLabelValuePair(label: element.name, value: "${element.id}"));
    });
    oldAttributeValues = widget.attributeValues;

    // in case of edit options not null
    if (widget.initialValue != null && widget.initialValue!.isNotEmpty) {
      oldValue = widget.initialValue ?? "";
      currentOption = widget.initialValue ?? attributeDropdown.first.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.attributeValues != oldAttributeValues) {
      attributeDropdown.clear();
      initialize();
    }
    if (widget.initialValue != oldValue) {
      currentOption = widget.initialValue ?? "";
      oldValue = widget.initialValue ?? "";
    }
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 8.0),
      child: Visibility(
        visible: attributeDropdown.isNotEmpty,
        child: SizedBox(
          width: 300,
          child: UpDropDown(
            key: GlobalKey(),
            onChanged: ((value) => {
                  widget.change!(value),
                }),
            value: currentOption,
            label: widget.attribute.name,
            itemList: attributeDropdown,
          ),
        ),
      ),
    );
  }
}
