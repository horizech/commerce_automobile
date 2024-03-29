import 'package:apiraiser/apiraiser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/helpers/up_toast.dart';
import 'package:flutter_up/themes/up_themes.dart';
import 'package:flutter_up/widgets/up_card.dart';
import 'package:flutter_up/widgets/up_list_tile.dart';
import 'package:flutter_up/widgets/up_scaffold.dart';
import 'package:shop/is_user_admin.dart';
import 'package:shop/widgets/add_media_widget.dart';
import 'package:shop/widgets/drawer/nav_drawer.dart';
import 'package:flutter_up/models/up_label_value.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_dropdown.dart';
import 'package:flutter_up/widgets/up_icon.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:flutter_up/widgets/up_textfield.dart';
import 'package:shop/dialogs/delete_dialog.dart';
import 'package:shop/models/attribute_value.dart';
import 'package:shop/models/attribute.dart';
import 'package:shop/services/add_edit_product_service/add_edit_product_service.dart';
import 'package:flutter_up/widgets/up_app_bar.dart';
import 'package:shop/widgets/store/store_cubit.dart';
import 'package:shop/widgets/unauthorized_widget.dart';

class AdminAttributesMob extends StatefulWidget {
  const AdminAttributesMob({Key? key}) : super(key: key);

  @override
  State<AdminAttributesMob> createState() => _AdminAttributesMobState();
}

class _AdminAttributesMobState extends State<AdminAttributesMob> {
  String currentAttribute = "";
  int? selectedMedia;
  List<Attribute> attributes = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController attributeValueNameController = TextEditingController();
  TextEditingController colorCodeController = TextEditingController();

  List<AttributeValue> attributeValues = [];
  List<UpLabelValuePair> swatches = [];
  String currentSwatch = "";
  Attribute selectedAttribute = const Attribute(name: "", id: -1, swatch: -1);
  List<AttributeValue> filteredAttributeValues = [];
  @override
  void initState() {
    super.initState();
    getAttributes();
    getAttributeValues();
  }

  _addEditAttributeValueDialog(AttributeValue? value) {
    if (value != null) {
      attributeValueNameController.text = value.name;
      colorCodeController.text = value.colorCode ?? "";
      selectedMedia = value.media;
    }
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                backgroundColor: UpConfig.of(context).theme.baseColor,
                title: Text(value != null
                    ? 'Edit attribute value'
                    : 'Add attribute value'),
                content: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SizedBox(
                    height: 200,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 250,
                                child: UpTextField(
                                  controller: attributeValueNameController,
                                  label: "Attribute Value",
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: swatches.isNotEmpty &&
                              swatches.any((element) =>
                                  element.label.toLowerCase() == 'image') &&
                              swatches
                                      .where((element) =>
                                          element.label.toLowerCase() ==
                                          'image')
                                      .first
                                      .value ==
                                  currentSwatch,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 300,
                              child: AddMediaWidget(
                                title: "Media",
                                selectedMedia: selectedMedia,
                                onChnage: (media) {
                                  selectedMedia = media;
                                  setState(() {});
                                },
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: swatches.isNotEmpty &&
                              swatches.any((element) =>
                                  element.label.toLowerCase() == 'color') &&
                              swatches
                                      .where((element) =>
                                          element.label.toLowerCase() ==
                                          'color')
                                      .first
                                      .value ==
                                  currentSwatch,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 250,
                              child: UpTextField(
                                hint: "Like #000000 ",
                                controller: colorCodeController,
                                label: "Hexa Code",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: SizedBox(
                      width: 100,
                      child: UpButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        text: "Cancel",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                    child: SizedBox(
                      width: 100,
                      child: UpButton(
                        text: value != null ? "Edit" : "Add",
                        onPressed: () {
                          _updateAttributeValue(value);
                          Navigator.pop(context, "success");
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        });
  }

  _updateAttributeValue(AttributeValue? value) async {
    if (attributeValueNameController.text.isNotEmpty &&
        selectedAttribute.id != -1) {
      AttributeValue newAttributeValue = AttributeValue(
          name: attributeValueNameController.text,
          attribute: selectedAttribute.id!,
          colorCode: colorCodeController.text,
          media: selectedMedia);
      APIResult? result = await AddEditProductService.addEditAttributeValues(
          data: newAttributeValue.toJson(newAttributeValue),
          attributeValueId: value?.id);
      if (result != null) {
        if (mounted) {
          UpToast().showToast(
            context: context,
            text: result.message ?? "",
          );
        }
        selectedMedia = null;
        attributeValueNameController.clear();
        colorCodeController.clear();
        getAttributeValues();
      } else {
        if (mounted) {
          UpToast().showToast(
            context: context,
            text: "An Error Occurred",
          );
        }
      }
    } else {
      UpToast().showToast(
        context: context,
        text: "Please enter attribute value name",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return UpScaffold(
      appBar: UpAppBar(
        style: UpStyle(
            iconColor: UpThemes.getContrastColor(
                UpConfig.of(context).theme.primaryColor)),
      ),
      drawer: const NavDrawer(),
      endDrawer: SafeArea(
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Drawer(
            child: leftSide(),
          );
        }),
      ),
      body: isUserAdmin()
          ? BlocConsumer<StoreCubit, StoreState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (swatches.isEmpty) {
                  if (state.attributeSwatches != null &&
                      state.attributeSwatches!.isNotEmpty) {
                    swatches
                        .add(UpLabelValuePair(label: "Select", value: "-1"));
                    for (var swatch in state.attributeSwatches!) {
                      swatches.add(UpLabelValuePair(
                          label: swatch.name, value: "${swatch.id}"));
                    }
                  }
                }
                if (attributeValues.isEmpty) {
                  if (state.attributeValues != null &&
                      state.attributeValues!.isNotEmpty) {
                    attributeValues = state.attributeValues!.toList();
                  }
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        UpCard(
                          header: Center(
                            child: UpText(
                              selectedAttribute.id == -1
                                  ? "Create Attribute"
                                  : "Update Attribute",
                              style: UpStyle(
                                  textSize: 24,
                                  textFontStyle: FontStyle.italic),
                            ),
                          ),
                          style: UpStyle(
                              cardWidth: MediaQuery.of(context).size.width - 32,
                              cardBodyPadding: false,
                              cardRadius: 8),
                          body: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          1.5,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: UpTextField(
                                              controller: nameController,
                                              label: 'Name',
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Visibility(
                                              visible: swatches.isNotEmpty,
                                              child: SizedBox(
                                                child: UpDropDown(
                                                  label: 'Swatch',
                                                  itemList: swatches,
                                                  value: currentSwatch,
                                                  onChanged: (value) {
                                                    currentSwatch = value ?? "";
                                                    setState(() {});
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: selectedAttribute.id != -1,
                                            child: const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: UpText(
                                                  "*To delete an attribute you must need to delete its attribute values"),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Visibility(
                                                visible:
                                                    selectedAttribute.id != -1,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: SizedBox(
                                                    width: 70,
                                                    height: 30,
                                                    child: UpButton(
                                                      onPressed: () {
                                                        _deleteAttribute(
                                                            selectedAttribute
                                                                .id!);
                                                      },
                                                      text: "Delete",
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: SizedBox(
                                                  width: 70,
                                                  height: 30,
                                                  child: UpButton(
                                                    onPressed: () {
                                                      _updateAttribute(
                                                        selectedAttribute.id !=
                                                                -1
                                                            ? selectedAttribute
                                                            : null,
                                                      );
                                                    },
                                                    text: "Save",
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 1.5,
                                    child: Visibility(
                                      visible: selectedAttribute.id != -1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4),
                                              child: Divider(
                                                  color: UpConfig.of(context)
                                                      .theme
                                                      .baseColor
                                                      .shade900,
                                                  thickness: 0.5),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: UpText(
                                                    "Add new attribute value",
                                                    style: UpStyle(
                                                        textSize: 12,
                                                        textFontStyle:
                                                            FontStyle.italic),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 30,
                                                height: 30,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    _addEditAttributeValueDialog(
                                                        null);
                                                  },
                                                  child: const UpIcon(
                                                    icon: Icons.add,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Visibility(
                                                visible: filteredAttributeValues
                                                    .isNotEmpty,
                                                child: SizedBox(
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        ...filteredAttributeValues
                                                            .map((e) => Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                    bottom: 8.0,
                                                                  ),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Flexible(
                                                                        child:
                                                                            UpText(
                                                                          e.name,
                                                                          style:
                                                                              UpStyle(
                                                                            textSize:
                                                                                16,
                                                                            textWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Wrap(
                                                                        children: [
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              _addEditAttributeValueDialog(e);
                                                                            },
                                                                            child:
                                                                                UpIcon(
                                                                              icon: Icons.edit,
                                                                              style: UpStyle(iconSize: 20),
                                                                            ),
                                                                          ),
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              _deleteAttributeValue(e.id!);
                                                                            },
                                                                            child:
                                                                                UpIcon(
                                                                              icon: Icons.delete,
                                                                              style: UpStyle(iconSize: 20),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                ))
                                                      ]),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : const UnAuthorizedWidget(),
    );
  }

  Widget leftSide() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: UpCard(
        style: UpStyle(cardWidth: 310, cardBodyPadding: false),
        body: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Column(
            children: [
              GestureDetector(
                  onTap: (() {
                    selectedAttribute =
                        const Attribute(name: "", id: -1, swatch: 0);
                    nameController.text = selectedAttribute.name;
                    currentSwatch = "-1";

                    setState(() {});
                  }),
                  child: Container(
                    color: selectedAttribute.id == -1
                        ? UpConfig.of(context).theme.primaryColor
                        : Colors.transparent,
                    child: UpListTile(
                      title: "Create a new attribute",
                      style: UpStyle(
                        listTileTextColor: selectedAttribute.id == -1
                            ? UpThemes.getContrastColor(
                                UpConfig.of(context).theme.primaryColor)
                            : UpConfig.of(context).theme.baseColor.shade900,
                      ),
                    ),
                  )),
              ...attributes
                  .map(
                    (e) => GestureDetector(
                      onTap: (() {
                        selectedAttribute = e;
                        if (swatches.isNotEmpty &&
                            swatches.any((element) =>
                                int.parse(element.value) ==
                                selectedAttribute.swatch)) {
                          currentSwatch = swatches
                              .where((element) =>
                                  int.parse(element.value) ==
                                  selectedAttribute.swatch)
                              .first
                              .value
                              .toString();
                        }
                        nameController.text = selectedAttribute.name;
                        _setAttributeValues();
                        Navigator.pop(context);
                        setState(() {});
                      }),
                      child: Container(
                        color: selectedAttribute.id == e.id
                            ? UpConfig.of(context).theme.primaryColor
                            : Colors.transparent,
                        child: UpListTile(
                          title: (e.name),
                          style: UpStyle(
                            listTileTextColor: selectedAttribute.id == e.id
                                ? UpThemes.getContrastColor(
                                    UpConfig.of(context).theme.primaryColor)
                                : UpConfig.of(context).theme.baseColor.shade900,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList()
            ],
          ),
        ),
      ),
    );
  }

  _updateAttribute(Attribute? attribute) async {
    if (nameController.text.isNotEmpty &&
        currentSwatch.isNotEmpty &&
        int.parse(currentSwatch) > 0) {
      Attribute newAttribute = Attribute(
        name: nameController.text,
        swatch: int.parse(currentSwatch),
      );
      APIResult? result = await AddEditProductService.addEditAttribute(
          data: newAttribute.toJson(newAttribute), attributeId: attribute?.id);

      if (result != null) {
        if (mounted) {
          UpToast().showToast(
            context: context,
            text: result.message ?? "",
          );
        }
        if (attribute == null) {
          nameController.text = "";
        }
        getAttributes();
      } else {
        if (mounted) {
          UpToast().showToast(
            context: context,
            text: "An Error Occurred",
          );
        }
      }
    } else {
      UpToast().showToast(
        context: context,
        text: "Please enter attribute name",
      );
    }
  }

  //by api
  getAttributes() async {
    List<Attribute>? newAttributes =
        await AddEditProductService.getAttributes();
    if (newAttributes != null && newAttributes.isNotEmpty) {
      attributes = newAttributes;

      setState(() {});
    }
  }

  getAttributeValues() async {
    if (selectedAttribute.id != -1) {
      List<AttributeValue>? newAttributeValues =
          await AddEditProductService.getAttributeValues();
      if (newAttributeValues != null && newAttributeValues.isNotEmpty) {
        attributeValues = newAttributeValues;
        _setAttributeValues();
        setState(() {});
      }
    }
  }

  _deleteAttribute(int attributeId) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const DeleteDialog();
      },
    ).then((result) async {
      if (result == "success") {
        APIResult? result =
            await AddEditProductService.deleteAttribute(attributeId);
        if (result != null && result.success) {
          if (mounted) {
            UpToast().showToast(context: context, text: result.message ?? "");
          }
          nameController.text = "";
          selectedAttribute = const Attribute(name: "", id: -1);
          getAttributes();
        } else {
          if (mounted) {
            UpToast().showToast(
              context: context,
              text: "An Error Occurred",
            );
          }
        }
      }
    });
  }

  _deleteAttributeValue(int attributeValueId) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const DeleteDialog();
      },
    ).then((result) async {
      if (result == "success") {
        APIResult? result =
            await AddEditProductService.deleteAttributeValue(attributeValueId);
        if (result != null && result.success) {
          if (mounted) {
            UpToast().showToast(context: context, text: result.message ?? "");
          }
          getAttributeValues();
        } else {
          if (mounted) {
            UpToast().showToast(
              context: context,
              text: "An Error Occurred",
            );
          }
        }
      }
    });
  }

  _setAttributeValues() {
    filteredAttributeValues = [];
    if (selectedAttribute.id != -1) {
      filteredAttributeValues = attributeValues
          .where((element) => element.attribute == selectedAttribute.id)
          .toList();
    }
  }
}
