class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final int? totalPages;
  final int? currentPage;
  final int? totalItems;
  
  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.totalPages,
    this.currentPage,
    this.totalItems,
  });
  
  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(dynamic)? fromJsonT) {
    return ApiResponse<T>(
      success: json['success'] ?? true,
      data: json['data'] != null ? fromJsonT?.call(json['data']) : null,
      message: json['message'],
      totalPages: json['total_pages'] ?? json['totalPages'],
      currentPage: json['current_page'] ?? json['currentPage'],
      totalItems: json['total_items'] ?? json['totalItems'],
    );
  }
}
