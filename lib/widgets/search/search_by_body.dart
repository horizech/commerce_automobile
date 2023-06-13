import 'package:flutter/material.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/services/up_navigation.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_card.dart';
import 'package:flutter_up/widgets/up_icon.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/attribute_value.dart';

import 'package:shop/services/variation.dart';

class SearchByBodyWidget extends StatelessWidget {
  final int collection;
  final List<AttributeValue> attributeValues;
  final int bodyTypeAttribute;
  const SearchByBodyWidget({
    super.key,
    required this.bodyTypeAttribute,
    required this.attributeValues,
    required this.collection,
  });

  gotoBodyType(id) {
    Map<String, List<int>> selectedVariationsValues = {
      "$bodyTypeAttribute": [id]
    };
    ServiceManager<VariationService>().setVariation(selectedVariationsValues);
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: attributeValues.isNotEmpty,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          ...attributeValues.map(
            (e) {
              return GestureDetector(
                  onTap: () {
                    gotoBodyType(e.id);
                    ServiceManager<UpNavigationService>()
                        .navigateToNamed(Routes.products, queryParams: {
                      "collection": '$collection',
                    });
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: SizedBox(
                      height: 80,
                      width: 100,
                      child: UpCard(
                        body: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            UpIcon(
                                icon: Icons.car_repair_rounded,
                                style: UpStyle(iconSize: 18)),
                            const SizedBox(height: 6),
                            UpText(
                              e.name,
                              style: UpStyle(textSize: 14),
                            )
                          ],
                        ),
                      ),
                    ),
                  ));
            },
          ),
        ],
      ),
    );
  }
}
