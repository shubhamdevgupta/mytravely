import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'core/constants.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/home_viewmodel.dart';
import 'viewmodels/search_viewmodel.dart';
import 'services/api_service.dart';
import 'repositories/hotel_repository.dart';
import 'repositories/auth_repository.dart';
import 'repositories/property_repository.dart';
import 'views/phone_login_page.dart';
import 'views/home_page.dart';
import 'views/search_results_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set device orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Services
        Provider<ApiService>(
          create: (_) => ApiService(),
        ),
        
        // Repositories
        Provider<AuthRepository>(
          create: (context) => AuthRepository(
            context.read<ApiService>(),
          ),
        ),
        Provider<HotelRepository>(
          create: (context) => HotelRepository(
            context.read<ApiService>(),
          ),
        ),
        Provider<PropertyRepository>(
          create: (context) => PropertyRepository(
            context.read<ApiService>(),
          ),
        ),
        
        // ViewModels
        ChangeNotifierProvider<AuthViewModel>(
          create: (context) => AuthViewModel(
            context.read<AuthRepository>(),
            context.read<ApiService>(),
          ),
        ),
        ChangeNotifierProvider<HomeViewModel>(
          create: (context) => HomeViewModel(
            context.read<HotelRepository>(),
          ),
        ),
        ChangeNotifierProvider<SearchViewModel>(
          create: (context) => SearchViewModel(
            context.read<HotelRepository>(),
          ),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'MyTravely',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                brightness: Brightness.light,
              ),
              useMaterial3: true,
              appBarTheme: const AppBarTheme(
                centerTitle: false,
                elevation: 0,
              ),
                             cardTheme: CardThemeData(
                 elevation: 2,
                 shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                 ),
               ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  ),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
              ),
            ),
            initialRoute: AppConstants.signInRoute,
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case AppConstants.signInRoute:
                  return MaterialPageRoute(builder: (_) => const PhoneLoginPage());
                
                case AppConstants.homeRoute:
                  return MaterialPageRoute(builder: (_) => const HomePage());
                
                case AppConstants.searchResultsRoute:
                  final query = settings.arguments as String? ?? '';
                  return MaterialPageRoute(
                    builder: (_) => SearchResultsPage(query: query),
                  );
                
                default:
                  return MaterialPageRoute(builder: (_) => const PhoneLoginPage());
              }
            },
            navigatorKey: NavigatorService.navigatorKey,
          );
        },
      ),
    );
  }
}

// Global navigation service
class NavigatorService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
