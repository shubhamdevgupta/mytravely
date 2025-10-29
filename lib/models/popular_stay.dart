class PopularStayItem {
  final String propertyName;
  final int? propertyStar;
  final String? propertyImage;
  final String propertyCode;
  final String propertyType;
  final double? markedAmount;
  final double? staticAmount;
  final double? googleRating;
  final int? googleTotalRatings;
  final String? city;
  final String? state;
  final String? country;

  PopularStayItem({
    required this.propertyName,
    required this.propertyCode,
    required this.propertyType,
    this.propertyStar,
    this.propertyImage,
    this.markedAmount,
    this.staticAmount,
    this.googleRating,
    this.googleTotalRatings,
    this.city,
    this.state,
    this.country,
  });

  factory PopularStayItem.fromJson(Map<String, dynamic> json) {
    final marked = (json['markedPrice'] is Map) ? (json['markedPrice'] as Map) : const {};
    final stat = (json['staticPrice'] is Map) ? (json['staticPrice'] as Map) : const {};
    final review = (json['googleReview'] is Map) ? (json['googleReview'] as Map) : const {};
    final reviewData = (review['data'] is Map) ? (review['data'] as Map) : const {};
    final addr = (json['propertyAddress'] is Map) ? (json['propertyAddress'] as Map) : const {};
    double? _toDouble(dynamic v) => v == null ? null : double.tryParse(v.toString());
    int? _toInt(dynamic v) => v == null ? null : int.tryParse(v.toString());
    return PopularStayItem(
      propertyName: (json['propertyName'] ?? '').toString(),
      propertyCode: (json['propertyCode'] ?? '').toString(),
      propertyType: (json['propertyType'] ?? '').toString(),
      propertyStar: _toInt(json['propertyStar']),
      propertyImage: json['propertyImage']?.toString(),
      markedAmount: _toDouble(marked['amount']),
      staticAmount: _toDouble(stat['amount']),
      googleRating: _toDouble(reviewData['overallRating']),
      googleTotalRatings: _toInt(reviewData['totalUserRating']),
      city: addr['city']?.toString(),
      state: addr['state']?.toString(),
      country: addr['country']?.toString(),
    );
  }
}


