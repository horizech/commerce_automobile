class Routes {
  static const String loginSignup = "/loginsignup";
  static const String home = "/home";
  static const String products = '/products';
  static const String product = '/product';
  static const String cart = '/cart';
  static const String payment = '/payment';
  static const String adminProducts = '/admin/products';
  static const String adminCombos = '/admin/combos';
  static const String admin = '/admin';
  static const String adminKeywords = '/admin/keywords';
  static const String adminMedia = '/admin/media';

  static const String adminAttributes = '/admin/attributes';
  static const String adminProductVariations = '/admin/product_variations';
  static const String addEditProduct = '/add_edit_product';
  static const String addEditProductVariaton = '/add_edit_product_variation';
  static const String adminGallery = '/admin/gallery';
  static const String adminProduct = '/admin/product';
  static const String searchAutomobile = '/search';
}

class Constant {
  static const String title = "Shop";
  static const String authLogin = "Login";
  static const String authLogout = "Logout";
  static const String authSignup = "Signup";
  static const String products = "Products";
  static const String combos = "Combos";
  static const String attributes = "Attributes";
  static const String productVariations = "Product Variations";
  static const String gallery = "Gallery";
  static const String keywords = "Keywords";
  static const String media = "Media";
}

Map<String, String> automobilePerformance = {
  "MP": "Max Power",
  "MT": "Max Torque",
  "MS": "Max Speed",
  "0-60T": "0-60 Time",
  "MPGE": "MPG Extra",
  "MPGC": "MPG Combined",
  "MPGU": "MPG Urban",
  "SatNav": "Satellite-navigation"
};

Map<String, String> automobileFeatures = {
  "SatNav": "Satellite-navigation",
  "CC": "Climate Control",
};

class Mode {
  static const String automobile = "automobile";
  static const String food = "Food";

  static String currentSelectedMode = Mode.food;
}
