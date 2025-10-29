class AutoCompleteSuggestion {
  final String valueToDisplay;
  final String? propertyName;
  final String? city;
  final String? state;
  final String searchType; // e.g., hotelIdSearch
  final List<String> query; // e.g., ["qyhZqzVt"]

  AutoCompleteSuggestion({
    required this.valueToDisplay,
    required this.propertyName,
    required this.city,
    required this.state,
    required this.searchType,
    required this.query,
  });

  factory AutoCompleteSuggestion.fromJson(Map<String, dynamic> json) {
    final address = (json['address'] is Map) ? (json['address'] as Map).cast<String, dynamic>() : <String, dynamic>{};
    final searchArray = (json['searchArray'] is Map) ? (json['searchArray'] as Map).cast<String, dynamic>() : <String, dynamic>{};
    final queryList = (searchArray['query'] is List)
        ? List<String>.from((searchArray['query'] as List).map((e) => e.toString()))
        : <String>[];
    return AutoCompleteSuggestion(
      valueToDisplay: (json['valueToDisplay'] ?? '').toString(),
      propertyName: json['propertyName']?.toString(),
      city: address['city']?.toString(),
      state: address['state']?.toString(),
      searchType: (searchArray['type'] ?? '').toString(),
      query: queryList,
    );
  }
}

class AutoCompleteResult {
  final bool present;
  final int totalNumberOfResult;
  final List<AutoCompleteSuggestion> byPropertyName;

  AutoCompleteResult({
    required this.present,
    required this.totalNumberOfResult,
    required this.byPropertyName,
  });

  factory AutoCompleteResult.fromApi(Map<String, dynamic> json) {
    final data = (json['data'] is Map) ? (json['data'] as Map).cast<String, dynamic>() : <String, dynamic>{};
    final autoList = (data['autoCompleteList'] is Map) ? (data['autoCompleteList'] as Map).cast<String, dynamic>() : <String, dynamic>{};
    final byProp = (autoList['byPropertyName'] is Map) ? (autoList['byPropertyName'] as Map).cast<String, dynamic>() : <String, dynamic>{};
    final listOfResult = (byProp['listOfResult'] is List) ? (byProp['listOfResult'] as List) : const [];
    final suggestions = listOfResult
        .whereType<Map>()
        .map((e) => AutoCompleteSuggestion.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
    return AutoCompleteResult(
      present: (data['present'] ?? false) == true,
      totalNumberOfResult: int.tryParse((data['totalNumberOfResult'] ?? 0).toString()) ?? 0,
      byPropertyName: suggestions,
    );
  }
}


