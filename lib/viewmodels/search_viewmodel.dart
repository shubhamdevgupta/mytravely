import 'package:flutter/foundation.dart';
import '../models/hotel.dart';
import '../repositories/hotel_repository.dart';

class SearchViewModel extends ChangeNotifier {
  final HotelRepository _repository;
  
  List<Hotel> _hotels = [];
  String _query = '';
  int _currentPage = 1;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  String? _errorMessage;
  
  List<Hotel> get hotels => _hotels;
  String get query => _query;
  int get currentPage => _currentPage;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  String? get errorMessage => _errorMessage;
  
  SearchViewModel(this._repository);
  
  Future<void> searchHotels(String query, {bool isNewSearch = true}) async {
    try {
      if (isNewSearch) {
        _isLoading = true;
        _currentPage = 1;
        _hotels = [];
        _query = query;
      } else {
        _isLoadingMore = true;
      }
      
      _errorMessage = null;
      notifyListeners();
      
      final List<Hotel> newHotels = await _repository.searchHotels(
        query: _query,
        page: _currentPage,
        pageSize: 10,
      );
      
      if (isNewSearch) {
        _hotels = newHotels;
      } else {
        _hotels.addAll(newHotels);
      }
      
      _hasMore = newHotels.isNotEmpty;
      _currentPage++;
      
      _isLoading = false;
      _isLoadingMore = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _isLoadingMore = false;
      _errorMessage = 'Failed to load hotels: ${e.toString()}';
      notifyListeners();
    }
  }
  
  Future<void> loadMore() async {
    if (!_isLoadingMore && _hasMore && !_isLoading) {
      await searchHotels(_query, isNewSearch: false);
    }
  }
  
  void clearSearch() {
    _hotels = [];
    _query = '';
    _currentPage = 1;
    _hasMore = true;
    _errorMessage = null;
    notifyListeners();
  }
  
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
