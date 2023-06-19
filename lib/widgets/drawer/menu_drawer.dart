import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/services/up_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_expansion_tile.dart';
import 'package:flutter_up/widgets/up_icon.dart';
import 'package:flutter_up/widgets/up_list_tile.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/constants.dart';
import 'package:shop/services/variation.dart';
import 'package:shop/widgets/store/store_cubit.dart';

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({Key? key}) : super(key: key);

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  @override
  Widget build(BuildContext context) {
    // CollectionTree? collectionTree;

    return BlocConsumer<StoreCubit, StoreState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Drawer(
          backgroundColor: UpConfig.of(context).theme.baseColor.shade50,
          child: SafeArea(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                SizedBox(
                  height: 150,
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Image.asset(
                          "automobilelogo.png",
                          height: 80,
                          width: 160,
                        ),
                        UpText(
                          'AutoMobile',
                          style: UpStyle(
                              textSize: 34, textWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  child: UpListTile(
                    onTap: () {
                      setState(() {
                        ServiceManager<UpNavigationService>()
                            .navigateToNamed(Routes.home);
                      });
                    },
                    leading: const UpIcon(icon: Icons.home),
                    title: 'Home',
                  ),
                ),
                SizedBox(
                  child: UpListTile(
                    onTap: () {
                      ServiceManager<VariationService>().removeVariation();

                      ServiceManager<UpNavigationService>()
                          .navigateToNamed(Routes.products, queryParams: {
                        "collection": '9',
                      });
                    },
                    leading: const UpIcon(icon: Icons.directions_car),
                    title: 'Used Cars',
                  ),
                ),
                SizedBox(
                  child: UpListTile(
                    onTap: () {
                      setState(() {
                        ServiceManager<UpNavigationService>()
                            .navigateToNamed(Routes.home);
                      });
                    },
                    leading: const UpIcon(icon: Icons.airport_shuttle),
                    title: 'Used Vans',
                  ),
                ),
                const SizedBox(
                  child: UpExpansionTile(
                    leading: UpIcon(icon: Icons.payments),
                    title: "Finance",
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 26.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              UpText(
                                "Car Finance",
                              ),
                              SizedBox(height: 4),
                              UpText(
                                "Finance Explaned",
                              ),
                              SizedBox(height: 4),
                              UpText(
                                "Free Finance Checker",
                              )
                            ]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  child: UpExpansionTile(
                    leading: const UpIcon(icon: Icons.price_check),
                    title: "Valuation",
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 26),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            UpText(
                              "Part Exchange",
                            ),
                            SizedBox(height: 4),
                            UpText(
                              "Sell Your Car",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  child: UpExpansionTile(
                    leading: UpIcon(icon: Icons.account_circle),
                    title: "About Us",
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 26.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              UpText(
                                "About Us",
                              ),
                              SizedBox(height: 4),
                              UpText(
                                "Reviews",
                              ),
                              SizedBox(height: 4),
                              UpText(
                                "Blog",
                              ),
                              SizedBox(height: 4),
                              UpText(
                                "Careers",
                              ),
                              SizedBox(height: 4),
                              UpText(
                                "Working with Us",
                              ),
                            ]),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  child: UpListTile(
                    onTap: () {
                      setState(() {
                        ServiceManager<UpNavigationService>()
                            .navigateToNamed(Routes.home);
                      });
                    },
                    leading: const UpIcon(
                      icon: Icons.location_on,
                    ),
                    title: 'Locations',
                  ),
                ),
                SizedBox(
                  child: UpListTile(
                    onTap: () {
                      setState(() {
                        ServiceManager<UpNavigationService>()
                            .navigateToNamed(Routes.home);
                      });
                    },
                    leading: const UpIcon(
                      icon: Icons.contact_mail_rounded,
                    ),
                    title: 'Contact Us',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
