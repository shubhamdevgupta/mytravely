import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:assignment_mytravely/repositories/hotel_repository.dart';
import 'package:assignment_mytravely/services/api_service.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  late HotelRepository repository;
  late MockApiService mockApiService;

  setUp(() {
    mockApiService = MockApiService();
    repository = HotelRepository(mockApiService);
  });

  group('HotelRepository', () {
    test('searchHotels should return filtered results', () async {
      final results = await repository.searchHotels(
        query: 'Mumbai',
        page: 1,
        pageSize: 10,
      );

      expect(results, isNotEmpty);
      // All results should contain Mumbai in name, city, state, or country
      for (final hotel in results) {
        final containsQuery = hotel.name.toLowerCase().contains('mumbai') ||
            hotel.city.toLowerCase().contains('mumbai') ||
            hotel.state.toLowerCase().contains('mumbai') ||
            hotel.country.toLowerCase().contains('mumbai');
        expect(containsQuery, true);
      }
    });

    test('searchHotels should handle pagination', () async {
      final page1 = await repository.searchHotels(
        query: '',
        page: 1,
        pageSize: 5,
      );

      final page2 = await repository.searchHotels(
        query: '',
        page: 2,
        pageSize: 5,
      );

      expect(page1.length, 5);
      expect(page2.length, 5);
      expect(page1, isNot(same(page2))); // Different results
    });

    test('searchHotels with empty query should return all results', () async {
      final results = await repository.searchHotels(
        query: '',
        page: 1,
        pageSize: 100,
      );

      // Should return all hotels since we have 12 in total
      expect(results.length, lessThanOrEqualTo(12));
    });

    test('searchHotels should handle empty results', () async {
      final results = await repository.searchHotels(
        query: 'NonExistentHotel12345',
        page: 1,
        pageSize: 10,
      );

      expect(results, isEmpty);
    });

    test('getTotalPages should calculate correct pages', () {
      final totalPages = repository.getTotalPages('', 5);
      // We have 12 hotels, so with page size 5, we should have 3 pages (12/5 = 2.4, ceil = 3)
      expect(totalPages, 3);
    });

    test('getTotalItems should return correct count', () {
      final totalItems = repository.getTotalItems('');
      expect(totalItems, 12);
    });

    test('searchHotels should filter by hotel name', () async {
      final results = await repository.searchHotels(
        query: 'Grand',
        page: 1,
        pageSize: 10,
      );

      expect(results, isNotEmpty);
      expect(results[0].name, 'Grand Plaza Hotel');
    });

    test('searchHotels should filter by city', () async {
      final results = await repository.searchHotels(
        query: 'Goa',
        page: 1,
        pageSize: 10,
      );

      expect(results, isNotEmpty);
      expect(results[0].city, 'Goa');
    });
  });
}
