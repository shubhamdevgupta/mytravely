class Hotel {
  final int id;
  final String name;
  final String city;
  final String state;
  final String country;
  final String? description;
  final String? imageUrl;
  
  Hotel({
    required this.id,
    required this.name,
    required this.city,
    required this.state,
    required this.country,
    this.description,
    this.imageUrl,
  });
  
  factory Hotel.fromJson(Map<String, dynamic> json) {
    final address = (json['address'] is Map)
        ? (json['address'] as Map).cast<String, dynamic>()
        : (json['propertyAddress'] is Map)
            ? (json['propertyAddress'] as Map).cast<String, dynamic>()
            : <String, dynamic>{};
    return Hotel(
      id: json['id'] ?? json['hotel_id'] ?? json['propertyCode']?.hashCode ?? 0,
      name: json['name'] ?? json['hotel_name'] ?? json['propertyName'] ?? 'Unknown Hotel',
      city: json['city'] ?? json['hotel_city'] ?? address['city']?.toString() ?? '',
      state: json['state'] ?? json['hotel_state'] ?? address['state']?.toString() ?? '',
      country: json['country'] ?? json['hotel_country'] ?? address['country']?.toString() ?? '',
      description: json['description'],
      imageUrl: json['image_url'] ?? json['imageUrl'] ?? json['thumbnail'] ?? json['image'] ?? json['propertyImage'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'state': state,
      'country': country,
      'description': description,
      'image_url': imageUrl,
    };
  }
}
