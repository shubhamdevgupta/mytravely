class Config {
  static const String baseUrl = 'https://api.mytravaly.com/public/v1/';
  
  // Public assignment token (frontend-only auth simulation)
  static const String apiAuthToken = '71523fdd8d26f585315b4233e39d9263';
  
  // API endpoints
  static const String registerEndpoint = 'auth/register';
  static const String loginEndpoint = 'auth/login';
  static const String propertiesEndpoint = 'properties';
  
  // Pagination
  static const int defaultPageSize = 10;
  
  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // API Version
  static const String apiVersion = 'v1';
}
