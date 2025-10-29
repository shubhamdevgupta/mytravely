import 'package:flutter/foundation.dart';
import '../repositories/auth_repository.dart';
import '../models/auth_response.dart';
import '../services/api_service.dart';
import '../core/config.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  final ApiService _apiService;
  
  bool _isLoading = false;
  String? _errorMessage;
  String? _authToken;
  String? _phoneNumber;
  
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get authToken => _authToken;
  String? get phoneNumber => _phoneNumber;
  bool get isSignedIn => _authToken != null;
  
  AuthViewModel(this._authRepository, this._apiService);
  
  // Frontend-only Google Sign-In simulation
  Future<bool> signInWithGoogleFrontend() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // 1) Register device with fixed assignment token to obtain visitor token
      final visitorToken = await _authRepository.registerDevice(
        deviceInfo: const {
          'deviceModel': 'RMX3521',
          'deviceFingerprint': 'realme/RMX3521/RE54E2L1:13/RKQ1.211119.001/S.f1bb32-7f7fa_1:user/release-keys',
          'deviceBrand': 'realme',
          'deviceId': 'RE54E2L1',
          'deviceName': 'RMX3521_11_C.10',
          'deviceManufacturer': 'realme',
          'deviceProduct': 'RMX3521',
          'deviceSerialNumber': 'unknown',
        },
      );

      if (visitorToken == null) {
        _isLoading = false;
        _errorMessage = 'Device registration failed';
        notifyListeners();
        return false;
      }

      // 2) Treat visitor token as session token; keep fixed authtoken as required
      _authToken = visitorToken;
      _apiService.setSessionTokens(
        authtoken: Config.apiAuthToken,
        visitortoken: visitorToken,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Google sign-in failed: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  Future<bool> registerWithPhone({
    required String phone,
    String? name,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      
      final AuthResponse response = await _authRepository.register(
        phone: phone,
        name: name,
      );
      
      if (response.success && response.token != null) {
        _authToken = response.token;
        _phoneNumber = phone;
        _apiService.setAuthToken(response.token!);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        _errorMessage = response.message ?? 'Registration failed';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Registration failed: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> loginWithPhone({
    required String phone,
  }) async {
  
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      
      final AuthResponse response = await _authRepository.login(
        phone: phone,
      );
      
      if (response.success && response.token != null) {
        _authToken = response.token;
        _phoneNumber = phone;
        _apiService.setAuthToken(response.token!);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        _errorMessage = response.message ?? 'Login failed';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Login failed: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }
  
  Future<void> signOut() async {
    try {
      _isLoading = true;
      notifyListeners();
      
      _apiService.clearAuthToken();
      _authToken = null;
      _phoneNumber = null;
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Sign out failed: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }
  
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
