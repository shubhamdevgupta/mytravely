import '../models/property.dart';
import '../services/api_service.dart';
import '../core/config.dart';

class PropertyRepository {
  final ApiService apiService;
  
  PropertyRepository(this.apiService);
  
  Future<List<Property>> searchProperties({
    required String query,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await apiService.get(
        Config.propertiesEndpoint,
        queryParameters: {
          'search': query,
          'page': page,
          'limit': pageSize,
        },
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        // Handle different API response formats
        List<dynamic>? propertiesList;
        if (data is Map<String, dynamic>) {
          if (data['data'] != null) {
            propertiesList = data['data'] is List ? data['data'] : [data['data']];
          } else if (data['properties'] != null) {
            propertiesList = data['properties'] is List ? data['properties'] : [data['properties']];
          } else {
            propertiesList = [data];
          }
        } else if (data is List) {
          propertiesList = data;
        }
        
        if (propertiesList != null && propertiesList.isNotEmpty) {
          return propertiesList.map((property) => Property.fromJson(property as Map<String, dynamic>)).toList();
        } else {
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
  
  Future<List<Property>> getProperties({
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await apiService.get(
        Config.propertiesEndpoint,
        queryParameters: {
          'page': page,
          'limit': pageSize,
        },
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        List<dynamic>? propertiesList;
        if (data is Map<String, dynamic>) {
          propertiesList = data['data'] is List ? data['data'] : [];
        } else if (data is List) {
          propertiesList = data;
        }
        
        if (propertiesList != null && propertiesList.isNotEmpty) {
          return propertiesList.map((property) => Property.fromJson(property as Map<String, dynamic>)).toList();
        } else {
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
