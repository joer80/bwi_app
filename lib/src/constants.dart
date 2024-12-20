class ApiConstants {
  static String baseUrl = 'https://ct.bwicompanies.com';
  static String usersEndpoint = '/api/v1/users/authenticated';
  static String setActiveAccountEndpoint = '/api/v1/users/active-account';
  static String customersEndpoint = '/api/v1/customers/'; // + customerId
  static String authEndpoint = '/api/auth/token?mobile=true';
  static String searchEndpoint = '/api/v1/items/search';
  static String itemsEndpoint = '/api/v1/items';
  static String upcEndpoint = '/api/v1/items/lookup/'; //+ upc
  static String cartEndpoint = '/api/v1/cart';
  static String checkoutEndpoint = '/api/v1/checkout/process';
  static String pickupLocationsEndpoint = '/api/v1/checkout/pickup-locations';
  static String deliveryMethodsEndpoint = '/api/v1/checkout/ship-methods';
  static String taxesEndpoint = '/api/v1/checkout/estimated-taxes';
  static String shippingEndpoint = '/api/v1/checkout/estimated-freight';
  static String ooEndpoint = '/api/v1/account/open-orders';
  static String phEndpoint = '/api/v1/account/purchase-history';
  static String promoEndpoint = '/api/v1/promotions';
  static String bbEndpoint = '/api/v1/promotions/bargain-barn';
}
