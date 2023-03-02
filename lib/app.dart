import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/themes/up_theme_data.dart';
import 'package:flutter_up/themes/up_themes.dart';
import 'package:apiraiser/apiraiser.dart';
import 'package:flutter_up/models/up_route.dart';
import 'package:flutter_up/models/up_router_state.dart';
import 'package:shop/pages/admin/add_edit_product.dart';
import 'package:shop/pages/admin/add_edit_product_variation.dart';
import 'package:shop/pages/admin/admin_product_options.dart';
import 'package:shop/pages/admin/admin_product_variations.dart';
import 'package:shop/pages/admin/admin_products.dart';
import 'package:shop/pages/authentication/loginsignup.dart';
import 'package:shop/pages/home/home.dart';

import 'package:shop/pages/product/product.dart';
import 'package:shop/pages/products/products_grid.dart';
import 'package:shop/pages/search/search.dart';
import 'package:shop/pages/store_dependant_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/up_app.dart';
import 'package:shop/constants.dart';
import 'package:shop/widgets/media/media_cubit.dart';
import 'package:shop/widgets/store/store_cubit.dart';

class ShopApp extends StatelessWidget {
  const ShopApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UpThemeData theme = UpThemes.generateThemeByColor(
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
              // primaryColor: Colors.greenAccent,
              primaryColor: const Color.fromRGBO(200, 16, 46, 1.0),
              secondaryColor: Colors.white,
            ),
            title: 'Shop',
            initialRoute: Routes.home,
            upRoutes: [
              UpRoute(
                path: Routes.loginSignup,
                pageBuilder: (BuildContext context, UpRouterState state) =>
                    const LoginSignupPage(),
                name: Routes.loginSignup,
                shouldRedirect: () => Apiraiser.authentication.isSignedIn(),
                redirectRoute: Routes.adminProduct,
              ),
              UpRoute(
                name: Routes.home,
                path: Routes.home,
                shouldRedirect: () => Apiraiser.authentication.isSignedIn(),
                redirectRoute: Routes.loginSignup,
                pageBuilder: (BuildContext context, UpRouterState state) =>
                    const StoreDependantPage(
                  page: HomePage(),
                ),
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
                name: Routes.adminProduct,
                path: Routes.adminProduct,
                pageBuilder: (BuildContext context, UpRouterState state) =>
                    const StoreDependantPage(
                  page: AdminPage(),
                ),
                redirectRoute: Routes.loginSignup,
                shouldRedirect: () => !Apiraiser.authentication.isSignedIn(),
              ),
              UpRoute(
                name: Routes.addEditProduct,
                path: Routes.addEditProduct,
                pageBuilder: (BuildContext context, UpRouterState state) =>
                    StoreDependantPage(
                  page: AddEditProduct(
                    queryParams: state.queryParams,
                  ),
                ),
                redirectRoute: Routes.loginSignup,
                shouldRedirect: () => !Apiraiser.authentication.isSignedIn(),
              ),
              UpRoute(
                name: Routes.adminProductVariations,
                path: Routes.adminProductVariations,
                pageBuilder: (BuildContext context, UpRouterState state) =>
                    StoreDependantPage(
                  page: AdminProductvariationsPage(
                    queryParams: state.queryParams,
                  ),
                ),
                redirectRoute: Routes.loginSignup,
                shouldRedirect: () => !Apiraiser.authentication.isSignedIn(),
              ),
              UpRoute(
                name: Routes.addEditProductVariaton,
                path: Routes.addEditProductVariaton,
                pageBuilder: (BuildContext context, UpRouterState state) =>
                    StoreDependantPage(
                  page: AddEditProductVariation(
                    queryParams: state.queryParams,
                  ),
                ),
                redirectRoute: Routes.loginSignup,
                shouldRedirect: () => !Apiraiser.authentication.isSignedIn(),
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
              UpRoute(
                name: Routes.adminProductOptions,
                path: Routes.adminProductOptions,
                pageBuilder: (BuildContext context, UpRouterState state) =>
                    const StoreDependantPage(
                  page: AdminProductOptionsPage(),
                ),
              ),
              UpRoute(
                name: Routes.products,
                path: Routes.products,
                pageBuilder: (BuildContext context, UpRouterState state) =>
                    StoreDependantPage(
                  page: ProductsGridPage(
                    queryParams: state.queryParams,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
