import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:assignment_mytravely/models/hotel.dart';
import 'package:assignment_mytravely/repositories/hotel_repository.dart';
import 'package:assignment_mytravely/viewmodels/search_viewmodel.dart';

class MockHotelRepository extends Mock implements HotelRepository {}

void main() {
  late SearchViewModel viewModel;
  late MockHotelRepository mockRepository;

  setUp(() {
    mockRepository = MockHotelRepository();
    viewModel = SearchViewModel(mockRepository);
  });

  group('SearchViewModel', () {
    test('initial state should be empty', () {
      expect(viewModel.hotels, isEmpty);
      expect(viewModel.query, isEmpty);
      expect(viewModel.currentPage, 1);
      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, isNull);
    });

    test('searchHotels should update state correctly', () async {
      const searchQuery = 'Mumbai';
      final mockHotels = [
        Hotel(
          id: 1,
          name: 'Test Hotel',
          city: 'Mumbai',
          state: 'Maharashtra',
          country: 'India',
        ),
      ];

      when(() => mockRepository.searchHotels(
            query: searchQuery,
            page: 1,
            pageSize: 10,
          )).thenAnswer((_) async => mockHotels);

      await viewModel.searchHotels(searchQuery);

      expect(viewModel.hotels, mockHotels);
      expect(viewModel.query, searchQuery);
      expect(viewModel.currentPage, 2);
      expect(viewModel.isLoading, false);
    });

    test('searchHotels should handle errors', () async {
      const searchQuery = 'Error';
      
      when(() => mockRepository.searchHotels(
            query: searchQuery,
            page: 1,
            pageSize: 10,
          )).thenThrow(Exception('API Error'));

      await viewModel.searchHotels(searchQuery);

      expect(viewModel.errorMessage, isNotNull);
      expect(viewModel.isLoading, false);
    });

    test('loadMore should load next page', () async {
      const searchQuery = 'Test';
      final mockHotelsPage1 = List.generate(10, (i) => Hotel(
        id: i,
        name: 'Hotel $i',
        city: 'City',
        state: 'State',
        country: 'Country',
      ));
      final mockHotelsPage2 = List.generate(10, (i) => Hotel(
        id: i + 10,
        name: 'Hotel ${i + 10}',
        city: 'City',
        state: 'State',
        country: 'Country',
      ));

      when(() => mockRepository.searchHotels(
            query: searchQuery,
            page: 1,
            pageSize: 10,
          )).thenAnswer((_) async => mockHotelsPage1);

      when(() => mockRepository.searchHotels(
            query: searchQuery,
            page: 2,
            pageSize: 10,
          )).thenAnswer((_) async => mockHotelsPage2);

      // Load first page
      await viewModel.searchHotels(searchQuery);
      expect(viewModel.hotels.length, 10);

      // Load more
      await viewModel.loadMore();
      expect(viewModel.hotels.length, 20);
    });

    test('clearSearch should reset state', () async {
      const searchQuery = 'Test';
      final mockHotels = [Hotel(
        id: 1,
        name: 'Test',
        city: 'City',
        state: 'State',
        country: 'Country',
      )];

      when(() => mockRepository.searchHotels(
            query: searchQuery,
            page: 1,
            pageSize: 10,
          )).thenAnswer((_) async => mockHotels);

      await viewModel.searchHotels(searchQuery);
      viewModel.clearSearch();

      expect(viewModel.hotels, isEmpty);
      expect(viewModel.query, isEmpty);
      expect(viewModel.currentPage, 1);
    });
  });
}
