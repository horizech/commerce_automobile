import 'package:flutter_up/locator.dart';
import 'package:flutter_up/services/up_navigation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_card.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/product.dart';
import 'package:shop/widgets/media/media_widget.dart';
import 'package:shop/widgets/price/price.dart';

class ProductGridItem extends StatelessWidget {
  final Product product;
  final int? collection;

  const ProductGridItem({
    Key? key,
    required this.product,
    this.collection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return getWebInfo(context, product, collection);
  }
}

Widget getWebInfo(BuildContext context, Product product, int? collection) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: GestureDetector(
      onTap: () {
        ServiceManager<UpNavigationService>().navigateToNamed(
          Routes.product,
          queryParams: {'productId': '${product.id}'},
        );
      },
      child: Wrap(children: [
        UpCard(
          body: SizedBox(
            height: 300,
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 280,
                  height: 192,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MediaWidget(
                      mediaId: product.thumbnail,
                      onChange: () => {
                        ServiceManager<UpNavigationService>().navigateToNamed(
                          Routes.product,
                          queryParams: {'productId': '${product.id}'},
                        ),
                      },
                    ),
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    // color: Colors.yellow[400],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        UpText(
                          product.name,
                          style: UpStyle(textSize: 20),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        PriceWidget(
                          price: product.price,
                          discountPrice: product.discounPrice,
                          discountStartDate: product.discountStartDate,
                          discountEndDate: product.discountEndDate,
                        ),
                      ],
                    ),
                  ),
                )),
              ],
            ),
          ),
        ),
      ]),
    ),
  );
}

// to check if there is discount or not
checkDisocunt(DateTime? discountStartDate, DateTime? disountEndDate) {
  bool isDiscount = false;
  // DateTime startDate = DateTime.parse(service_start_date);
  // DateTime endDate = DateTime.parse(service_end_date);

  DateTime currentDate = DateTime.now();
  if (discountStartDate != null && disountEndDate != null) {
    if (discountStartDate.isBefore(currentDate) &&
        disountEndDate.isAfter(currentDate)) {
      isDiscount = true;
    }
  }
  return isDiscount;
}
