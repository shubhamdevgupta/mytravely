import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:assignment_mytravely/viewmodels/home_viewmodel.dart';
import 'package:assignment_mytravely/repositories/hotel_repository.dart';
import 'package:assignment_mytravely/views/home_page.dart';

class MockHotelRepository extends Mock implements HotelRepository {}

void main() {
  group('HomePage Widget Tests', () {
    late MockHotelRepository mockRepository;
    
    setUp(() {
      mockRepository = MockHotelRepository();
    });

    Widget createTestWidget() {
      return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            home: ChangeNotifierProvider(
              create: (_) => HomeViewModel(mockRepository),
              child: const HomePage(),
            ),
          );
        },
      );
    }

    testWidgets('home page initializes without errors', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // The page should render without errors
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
