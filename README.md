# MyTravely - Hotel Search App

A production-ready Flutter application built with MVVM architecture, Provider state management, and clean code principles.

## 📱 Features

### Page 1 - Google Sign-In
- Modern Google Sign-In UI
- Loading and error state handling
- Frontend-only authentication simulation
- Seamless navigation to Home Page

### Page 2 - Home Page
- Sample hotel listings
- Real-time search filter (by name, city, state, country)
- Search button to navigate to results page
- Clean and modern Material 3 UI

### Page 3 - Search Results
- API-driven hotel search with pagination
- Infinite scroll / lazy loading
- Loading shimmer effects
- Error handling with retry functionality
- Displays hotel details (name, city, state, country)

## 🏗 Architecture

### MVVM + Provider Pattern
```
lib/
├── core/              # Constants and config
├── models/            # Data models
├── repositories/      # Data access layer
├── services/          # API services (Dio)
├── viewmodels/        # Business logic (ChangeNotifier)
├── views/             # UI screens
└── widgets/           # Reusable components
```

### State Management
- **Provider** for dependency injection and state management
- **ChangeNotifier** for reactive UI updates
- **Consumer** widgets for optimized rebuilds

### Networking
- **Dio** for HTTP requests with interceptors
- Error handling and timeout configuration
- Auth token injection

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.9.2 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd assignment_mytravely
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## 🧪 Testing

Run all tests:
```bash
flutter test
```

Test coverage includes:
- ✅ Unit tests for ViewModels
- ✅ Unit tests for Repository
- ✅ Unit tests for Models
- ✅ Widget tests for UI components

### Test Structure
```
test/
├── models/
│   └── hotel_test.dart
├── repositories/
│   └── hotel_repository_test.dart
├── viewmodels/
│   └── search_viewmodel_test.dart
└── widgets/
    └── home_page_test.dart
```

## 📦 Dependencies

### Main Dependencies
- `provider: ^6.1.2` - State management
- `dio: ^5.4.1` - HTTP client
- `google_sign_in: ^6.2.1` - Google sign-in UI
- `shimmer: ^3.0.0` - Loading animations
- `flutter_screenutil: ^5.9.0` - Responsive design

### Dev Dependencies
- `flutter_lints: ^5.0.0` - Linting rules
- `mocktail: ^1.0.1` - Mocking for tests

## 🎨 UI/UX Features

- ✅ Fully responsive design using `flutter_screenutil`
- ✅ Material 3 design system
- ✅ Shimmer loading effects
- ✅ Error states with retry functionality
- ✅ Empty states with helpful messages
- ✅ Smooth animations and transitions

## 📱 Screens

### 1. Sign-In Page
- Welcome screen with app branding
- Google Sign-In button
- Terms and Privacy notice
- Loading and error states

### 2. Home Page
- Search bar with filter
- Hotel card list
- Real-time search filtering
- Logout functionality

### 3. Search Results Page
- Paginated results
- Infinite scroll
- Results counter
- Loading indicators
- Error handling

## 🔧 Configuration

### API Configuration
Edit `lib/core/config.dart`:
```dart
class Config {
  static const String baseUrl = 'https://api.mytravaly.com/public/v1/';
  static const String authToken = '71523fdd8d26f585315b4233e39d9263';
}
```

## 📱 Responsive Design

The app uses `flutter_screenutil` for responsive design across different screen sizes:
- Adaptive text sizes
- Flexible layouts
- Scalable spacing
- Multi-screen support

## 🔒 Best Practices

- ✅ Clean Architecture with separation of concerns
- ✅ Repository pattern for data access
- ✅ Dependency injection with Provider
- ✅ Null safety throughout
- ✅ Error boundary handling
- ✅ Loading state management
- ✅ Comprehensive test coverage

## 📝 Code Quality

- Follows Flutter best practices
- Proper null safety implementation
- Async/await pattern
- Error handling
- Code comments where necessary
- Consistent naming conventions

## 🚀 Build for Production

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License.

## 👨‍💻 Author

Assignment for MyTravely

---

**Note**: This is a frontend-only implementation. Google Sign-In is simulated for UI demonstration purposes only.
