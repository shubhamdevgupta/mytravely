import 'package:flutter_test/flutter_test.dart';
import 'package:assignment_mytravely/models/hotel.dart';

void main() {
  group('Hotel Model', () {
    test('fromJson creates Hotel correctly', () {
      final json = {
        'id': 1,
        'name': 'Test Hotel',
        'city': 'Mumbai',
        'state': 'Maharashtra',
        'country': 'India',
        'description': 'A test hotel',
        'image_url': 'https://example.com/image.jpg',
      };

      final hotel = Hotel.fromJson(json);

      expect(hotel.id, 1);
      expect(hotel.name, 'Test Hotel');
      expect(hotel.city, 'Mumbai');
      expect(hotel.state, 'Maharashtra');
      expect(hotel.country, 'India');
      expect(hotel.description, 'A test hotel');
      expect(hotel.imageUrl, 'https://example.com/image.jpg');
    });

    test('fromJson handles missing optional fields', () {
      final json = {
        'id': 1,
        'name': 'Test Hotel',
        'city': 'Mumbai',
        'state': 'Maharashtra',
        'country': 'India',
      };

      final hotel = Hotel.fromJson(json);

      expect(hotel.id, 1);
      expect(hotel.name, 'Test Hotel');
      expect(hotel.description, isNull);
      expect(hotel.imageUrl, isNull);
    });

    test('fromJson handles missing required fields with defaults', () {
      final json = {
        'id': null,
        'name': null,
        'city': null,
        'state': null,
        'country': null,
      };

      final hotel = Hotel.fromJson(json);

      expect(hotel.id, 0);
      expect(hotel.name, 'Unknown Hotel');
      expect(hotel.city, '');
      expect(hotel.state, '');
      expect(hotel.country, '');
    });

    test('toJson converts Hotel to map correctly', () {
      final hotel = Hotel(
        id: 1,
        name: 'Test Hotel',
        city: 'Mumbai',
        state: 'Maharashtra',
        country: 'India',
        description: 'A test hotel',
        imageUrl: 'https://example.com/image.jpg',
      );

      final json = hotel.toJson();

      expect(json['id'], 1);
      expect(json['name'], 'Test Hotel');
      expect(json['city'], 'Mumbai');
      expect(json['state'], 'Maharashtra');
      expect(json['country'], 'India');
      expect(json['description'], 'A test hotel');
      expect(json['image_url'], 'https://example.com/image.jpg');
    });

    test('toJson omits null optional fields', () {
      final hotel = Hotel(
        id: 1,
        name: 'Test Hotel',
        city: 'Mumbai',
        state: 'Maharashtra',
        country: 'India',
      );

      final json = hotel.toJson();

      expect(json['description'], isNull);
      expect(json['image_url'], isNull);
    });
  });
}
