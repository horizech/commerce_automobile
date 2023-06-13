import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/themes/up_theme_data.dart';
import 'package:flutter_up/themes/up_themes.dart';
import 'package:apiraiser/apiraiser.dart';
import 'package:flutter_up/models/up_route.dart';
import 'package:flutter_up/models/up_router_state.dart';
import 'package:flutter_up/widgets/up_responsive_page.dart';
import 'package:shop/pages/admin/admin_attributes_mob.dart';
import 'package:shop/pages/admin/admin_combos_mob.dart';
import 'package:shop/pages/admin/admin_gallery_mob.dart';
import 'package:shop/pages/admin/admin_keywords_mob.dart';
import 'package:shop/pages/admin/admin_media.dart';
import 'package:shop/pages/admin/admin_media_mob.dart';
import 'package:shop/pages/admin/admin_products_mob.dart';
import 'package:shop/pages/authentication/loginsignup.dart';
import 'package:shop/pages/home/home.dart';

import 'package:shop/pages/product/product.dart';
import 'package:shop/pages/products/products_grid.dart';
import 'package:shop/pages/products/products_grid_mob.dart';
import 'package:shop/pages/search/search.dart';
import 'package:shop/pages/store_dependant_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/up_app.dart';
import 'package:shop/constants.dart';
import 'package:shop/widgets/media/media_cubit.dart';
import 'package:shop/widgets/store/store_cubit.dart';

import 'package:shop/pages/admin/admin.dart';
import 'package:shop/pages/admin/admin_combos.dart';
import 'package:shop/pages/admin/admin_gallery.dart';
import 'package:shop/pages/admin/admin_keywords.dart';
import 'package:shop/pages/admin/admin_attributes.dart';
import 'package:shop/pages/admin/admin_products.dart';

class ShopApp extends StatelessWidget {
  const ShopApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UpThemeData theme = UpThemes.generateThemeByColor(
      baseColor: Colors.black,
      isDark: true,
      primaryColor: const Color.fromRGBO(
        64,
        64,
        64,
        1.0,
      ),
    );
    theme.primaryStyle = theme.primaryStyle.copyWith(
      UpStyle(textColor: Colors.white, iconColor: Colors.white),
    );

    return BlocProvider(
        create: (_) => Mediacubit(),
        child: BlocProvider(
          create: (_) => StoreCubit(),
          child: UpApp(
            theme: UpThemes.generateThemeByColor(
              isDark: true,
              baseColor: const Color.fromARGB(255, 63, 63, 63),
              // baseColor: Colors.white,
              // primaryColor: Colors.purple,
              primaryColor: const Color.fromRGBO(200, 16, 46, 1.0),
              secondaryColor: Colors.white,
              tertiaryColor: const Color.fromARGB(255, 222, 84, 107),
              warnColor: Colors.red,
              successColor: Colors.green,
            ),
            title: 'Shop',
            initialRoute: Routes.home,
            upRoutes: [
              UpRoute(
                name: Routes.home,
                path: Routes.home,
                pageBuilder: (BuildContext context, UpRouterState state) =>
                    const StoreDependantPage(
                  page: HomePage(),
                ),
              ),
              UpRoute(
                path: Routes.loginSignup,
                pageBuilder: (BuildContext context, UpRouterState state) =>
                    const LoginSignupPage(),
                name: Routes.loginSignup,
                shouldRedirect: () => Apiraiser.authentication.isSignedIn(),
                redirectRoute: Routes.home,
              ),
              UpRoute(
                name: Routes.searchAutomobile,
                path: Routes.searchAutomobile,
                pageBuilder: (BuildContext context, UpRouterState state) =>
                    const StoreDependantPage(
                  page: SearchPage(),
                ),
              ),
              UpRoute(
                name: Routes.product,
                path: Routes.product,
                pageBuilder: (BuildContext context, UpRouterState state) =>
                    StoreDependantPage(
                  page: ProductPage(
                    queryParams: state.queryParams,
                  ),
                ),
              ),
              // UpRoute(
              //   name: Routes.products,
              //   path: Routes.products,
              //   pageBuilder: (BuildContext context, UpRouterState state) =>
              //       StoreDependantPage(
              //     page: ProductsGridPageMob(
              //       queryParams: state.queryParams,
              //     ),
              //   ),
              // ),
              UpRoute(
                name: Routes.products,
                path: Routes.products,
                pageBuilder: (BuildContext context, UpRouterState state) =>
                    UpResponsivePage(
                  desktopPage: ProductsGridPage(
                    queryParams: state.queryParams,
                  ),
                  mobilePage: ProductsGridPageMob(
                    queryParams: state.queryParams,
                  ),
                ),
              ),
              UpRoute(
                path: Routes.adminCombos,
                name: Routes.adminCombos,
                pageBuilder: (BuildContext context, UpRouterState state) =>
                    const UpResponsivePage(
                  desktopPage: AdminCombos(),
                  mobilePage: AdminCombosMob(),
                ),
                shouldRedirect: () => !Apiraiser.authentication.isSignedIn(),
                redirectRoute: Routes.loginSignup,
              ),
              UpRoute(
                path: Routes.adminProducts,
                name: Routes.adminProducts,
                pageBuilder: (BuildContext context, UpRouterState state) =>
                    const UpResponsivePage(
                  desktopPage: AdminProducts(),
                  mobilePage: AdminProductsMob(),
                ),
                shouldRedirect: () => !Apiraiser.authentication.isSignedIn(),
                redirectRoute: Routes.loginSignup,
              ),
              UpRoute(
                path: Routes.adminAttributes,
                name: Routes.adminAttributes,
                pageBuilder: (BuildContext context, UpRouterState state) =>
                    const UpResponsivePage(
                  desktopPage: AdminAttributes(),
                  mobilePage: AdminAttributesMob(),
                ),
                shouldRedirect: () => !Apiraiser.authentication.isSignedIn(),
                redirectRoute: Routes.loginSignup,
              ),
              UpRoute(
                path: Routes.adminMedia,
                name: Routes.adminMedia,
                pageBuilder: (BuildContext context, UpRouterState state) =>
                    const UpResponsivePage(
                  desktopPage: AdminMedia(),
                  mobilePage: AdminMediaMob(),
                ),
                shouldRedirect: () => !Apiraiser.authentication.isSignedIn(),
                redirectRoute: Routes.loginSignup,
              ),
              UpRoute(
                path: Routes.adminGallery,
                name: Routes.adminGallery,
                pageBuilder: (BuildContext context, UpRouterState state) =>
                    const UpResponsivePage(
                  desktopPage: AdminGallery(),
                  mobilePage: AdminGalleryMob(),
                ),
                shouldRedirect: () => !Apiraiser.authentication.isSignedIn(),
                redirectRoute: Routes.loginSignup,
              ),
              UpRoute(
                path: Routes.admin,
                name: Routes.admin,
                pageBuilder: (BuildContext context, UpRouterState state) =>
                    const StoreDependantPage(
                  page: Admin(),
                ),
                shouldRedirect: () => !Apiraiser.authentication.isSignedIn(),
                redirectRoute: Routes.loginSignup,
              ),
              UpRoute(
                path: Routes.adminKeywords,
                name: Routes.adminKeywords,
                pageBuilder: (BuildContext context, UpRouterState state) =>
                    const UpResponsivePage(
                  desktopPage: AdminKeywords(),
                  mobilePage: AdminKeywordsMob(),
                ),
                shouldRedirect: () => !Apiraiser.authentication.isSignedIn(),
                redirectRoute: Routes.loginSignup,
              ),
            ],
          ),
        ));
  }
}
