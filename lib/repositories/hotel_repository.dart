import '../models/hotel.dart';
import '../models/auto_complete.dart';
import '../services/api_service.dart';

class HotelRepository {
  final ApiService apiService;
  
  HotelRepository(this.apiService);
  
  // 1) searchAutoComplete only (display suggestions as results)
  Future<List<Hotel>> searchHotels({
    required String query,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      // Request up to current page worth of results to support client-side paging
      final effectiveLimit = page * pageSize;
      final acResponse = await apiService.post(
        '',
        data: {
          'action': 'searchAutoComplete',
          'searchAutoComplete': {
            'inputText': query,
            'searchType': [
              'byCity',
              'byState',
              'byCountry',
              'byRandom',
              'byPropertyName',
            ],
            'limit': effectiveLimit,
          },
        },
      );
      if (acResponse.statusCode != 200) return [];
      final autoComplete = AutoCompleteResult.fromApi(acResponse.data as Map<String, dynamic>);
      final suggestions = autoComplete.byPropertyName;
      if (suggestions.isEmpty) return [];

      // Client-side pagination of suggestions
      final start = (page - 1) * pageSize;
      final end = (start + pageSize) > suggestions.length ? suggestions.length : (start + pageSize);
      if (start >= end) return [];
      final pageItems = suggestions.sublist(start, end);
      // Map suggestions to lightweight Hotel rows
      return pageItems
          .map((s) => Hotel(
                id: s.valueToDisplay.hashCode,
                name: s.propertyName ?? s.valueToDisplay,
                city: s.city ?? '',
                state: s.state ?? '',
                country: '',
                description: null,
                imageUrl: null,
              ))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // 2) popularStay
  Future<List<Hotel>> getPopularStays({
    int limit = 10,
    String entityType = 'Any',
    String searchType = 'byCity',
    String country = 'India',
    String state = 'Jharkhand',
    String city = 'Jamshedpur',
    String currency = 'INR',
  }) async {
    try {
      final response = await apiService.post(
        '',
        data: {
          'action': 'popularStay',
          'popularStay': {
            'limit': limit,
            'entityType': entityType,
            'filter': {
              'searchType': searchType,
              'searchTypeInfo': {
                'country': country,
                'state': state,
                'city': city,
              },
            },
            'currency': currency,
          },
        },
      );
      if (response.statusCode == 200) {
        final data = response.data;
        final List<dynamic> hotelsList =
            (data is Map && data['data'] is List)
                ? List<dynamic>.from(data['data'])
                : (data is Map && data['results'] is List)
                    ? List<dynamic>.from(data['results'])
                    : (data is List)
                        ? data
                        : [];
        return hotelsList
            .map((hotel) => Hotel.fromJson((hotel as Map).cast<String, dynamic>()))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // 3) getSearchResultListOfHotels
  Future<List<Hotel>> getSearchResultListOfHotels({
    required Map<String, dynamic> searchCriteria,
  }) async {
    try {
      final response = await apiService.post(
        '',
        data: {
          'action': 'getSearchResultListOfHotels',
          'getSearchResultListOfHotels': {
            'searchCriteria': searchCriteria,
          },
        },
      );
      if (response.statusCode == 200) {
        final data = response.data;
        final List<dynamic> hotelsList =
            (data is Map && data['data'] is List)
                ? List<dynamic>.from(data['data'])
                : (data is Map && data['results'] is List)
                    ? List<dynamic>.from(data['results'])
                    : (data is List)
                        ? data
                        : [];
        return hotelsList
            .map((hotel) => Hotel.fromJson((hotel as Map).cast<String, dynamic>()))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
  
  
  int getTotalPages(String query, int pageSize) {
    // This would need to come from API response
    // For now, return 0
    return 0;
  }
  
  int getTotalItems(String query) {
    // This would need to come from API response
    // For now, return 0
    return 0;
  }
}
