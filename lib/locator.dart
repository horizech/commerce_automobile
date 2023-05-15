import 'package:flutter_up/locator.dart';
import 'package:shop/services/variation.dart';
import 'package:shop/widgets/products/scroll_to_top_service.dart';

void setupLocator() {
  setupFlutterUpLocators([
    FlutterUpLocators.upDialogService,
    FlutterUpLocators.upNavigationService,
    FlutterUpLocators.upScaffoldHelperService,
    FlutterUpLocators.upSearchService,
    FlutterUpLocators.upUrlService,
    FlutterUpLocators.upLayoutService
  ]);
  ServiceManager.registerLazySingleton(() => VariationService());
  ServiceManager.registerLazySingleton(() => ScrollToTopService());
}
