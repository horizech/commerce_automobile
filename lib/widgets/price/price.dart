import 'package:flutter/material.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/models/product.dart';

class PriceWidget extends StatelessWidget {
  final double? price;
  final double? discountPrice;
  final DateTime? discountStartDate;
  final DateTime? discountEndDate;

  const PriceWidget(
      {Key? key,
      this.price,
      this.discountPrice,
      this.discountStartDate,
      this.discountEndDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return price != null
        ? checkDisocunt(discountStartDate, discountEndDate)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  UpText(
                    "${getDiscountPercentage(price, discountPrice).toString()}% discount",
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UpText(
                        price.toString(),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      UpText(
                        discountPrice.toString(),
                      ),
                    ],
                  ),
                ],
              )
            : Align(
                alignment: Alignment.topLeft, child: UpText(price.toString()))
        : const Text("");
  }
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

getDiscountPercentage(double? price, double? discountPrice) {
  double percentage = 0;
  if (price != null && discountPrice != null) {
    percentage = 100 - ((discountPrice / price) * 100);
  }
  return percentage.ceilToDouble();
}

getPrice(Product product) {
  double? price = 0;
  bool isDisocunt =
      checkDisocunt(product.discountStartDate, product.discountEndDate);
  if (isDisocunt) {
    price = product.discounPrice;
  } else {
    price = product.price;
  }
  return price;
}
