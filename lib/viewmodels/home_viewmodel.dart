import 'package:flutter/foundation.dart';
import '../models/hotel.dart';
import '../repositories/hotel_repository.dart';
import '../sample/sample_hotels.dart';

class HomeViewModel extends ChangeNotifier {
  final HotelRepository _repository;
  
  List<Hotel> _hotels = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';
  
  List<Hotel> get sampleHotels => _hotels;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  
  HomeViewModel(this._repository) {
    _loadHotels();
  }
  
  Future<void> _loadHotels() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      
      // Prefer API popularStay if tokens are present; fallback to samples
      final apiResults = await _repository.getPopularStays(limit: 10);
      _hotels = apiResults.isNotEmpty ? apiResults : SampleHotels.list;
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load hotels: ${e.toString()}';
      notifyListeners();
    }
  }
  
  List<Hotel> get filteredHotels {
    if (_searchQuery.isEmpty) {
      return _hotels;
    }
    
    final lowerQuery = _searchQuery.toLowerCase();
    return _hotels.where((hotel) {
      return hotel.name.toLowerCase().contains(lowerQuery) ||
          hotel.city.toLowerCase().contains(lowerQuery) ||
          hotel.state.toLowerCase().contains(lowerQuery) ||
          hotel.country.toLowerCase().contains(lowerQuery);
    }).toList();
  }
  
  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
  
  Future<void> refresh() async {
    await _loadHotels();
  }
  
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
