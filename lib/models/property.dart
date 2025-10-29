class Property {
  final String? id;
  final String? name;
  final String? city;
  final String? state;
  final String? country;
  final String? description;
  final String? imageUrl;
  final Map<String, dynamic>? address;
  
  Property({
    this.id,
    this.name,
    this.city,
    this.state,
    this.country,
    this.description,
    this.imageUrl,
    this.address,
  });
  
  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id']?.toString() ?? json['_id']?.toString(),
      name: json['name'] ?? json['propertyName'] ?? 'Unknown Property',
      city: json['city'] ?? json['address']?['city'] ?? '',
      state: json['state'] ?? json['address']?['state'] ?? '',
      country: json['country'] ?? json['address']?['country'] ?? '',
      description: json['description'],
      imageUrl: json['imageUrl'] ?? json['image_url'],
      address: json['address'] as Map<String, dynamic>?,
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
