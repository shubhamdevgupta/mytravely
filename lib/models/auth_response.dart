class AuthResponse {
  final bool success;
  final String? token;
  final String? message;
  final Map<String, dynamic>? user;
  
  AuthResponse({
    required this.success,
    this.token,
    this.message,
    this.user,
  });
  
  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] ?? false,
      token: json['token'] ?? json['data']?['token'],
      message: json['message'],
      user: json['user'] ?? json['data']?['user'],
    );
  }
}
