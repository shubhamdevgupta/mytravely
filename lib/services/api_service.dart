import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../core/config.dart';

class ApiService {
  late Dio _dio;
  
  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: Config.baseUrl,
        connectTimeout: Config.connectionTimeout,
        receiveTimeout: Config.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        // Do not throw for non-2xx; handle manually
        validateStatus: (status) => true,
      ),
    );
    
    _setupInterceptors();
  }
  
  // Preferred: set both tokens for subsequent API calls
  void setSessionTokens({required String authtoken, required String visitortoken}) {
    _dio.options.headers['authtoken'] = authtoken;
    _dio.options.headers['visitortoken'] = visitortoken;
  }
  
  // Backward-compat: set only visitor token
  void setAuthToken(String token) {
    _dio.options.headers['visitortoken'] = token;
  }
  
  void clearAuthToken() {
    _dio.options.headers.remove('visitortoken');
    _dio.options.headers.remove('authtoken');
  }
  
  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint('[API][REQ] ${options.method} ${options.baseUrl}${options.path}');
          debugPrint('[API][HEADERS] ${options.headers}');
          if (options.data != null) {
            debugPrint('[API][BODY] ${options.data}');
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint('[API][RES] ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.path}');
          debugPrint('[API][DATA] ${response.data}');
          handler.next(response);
        },
        onError: (error, handler) {
          debugPrint('[API][ERR] ${error.message}');
          if (error.response != null) {
              debugPrint('[API][ERR][STATUS] ${error.response?.statusCode}');
              debugPrint('[API][ERR][DATA] ${error.response?.data}');
          }
          handler.next(error);
        },
      ),
    );
  }
  
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      if ((response.statusCode ?? 0) >= 200 && (response.statusCode ?? 0) < 300) {
        return response;
      }
      throw _formatHttpError(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      if ((response.statusCode ?? 0) >= 200 && (response.statusCode ?? 0) < 300) {
        return response;
      }
      throw _formatHttpError(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  // One-off POST with a specific Authorization token (does not persist it)
  Future<Response> postWithAuthToken(
    String path, {
    required String authToken,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final mergedOptions = Options(
        headers: {
          ..._dio.options.headers,
          // For device registration, API expects fixed token in 'authtoken'
          'authtoken': authToken,
        },
      );
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: mergedOptions,
      );
      if ((response.statusCode ?? 0) >= 200 && (response.statusCode ?? 0) < 300) {
        return response;
      }
      throw _formatHttpError(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _formatHttpError(Response response) {
    try {
      final data = response.data;
      if (data is Map && data['message'] is String) {
        return data['message'] as String;
      }
      return 'HTTP ${response.statusCode}: ${response.statusMessage ?? 'Request failed'}';
    } catch (_) {
      return 'HTTP ${response.statusCode}: ${response.statusMessage ?? 'Request failed'}';
    }
  }
  
  String _handleError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'Connection timeout. Please try again.';
    } else if (error.type == DioExceptionType.connectionError) {
      return 'No internet connection. Please check your network.';
    } else if (error.response != null) {
      return error.response?.data['message'] ?? 'Server error occurred';
    } else {
      return 'Something went wrong. Please try again.';
    }
  }
}
