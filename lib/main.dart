import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // This will work after pub get
import 'providers/theme_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/todo_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/about_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/venue_booking_screen.dart';
import 'screens/document_tracker_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/todo_screen.dart';
import 'screens/gallery_screen.dart';
import 'screens/media_screen.dart';
import 'screens/main_shell.dart';

void main() {
  runApp(
    MultiProvider(
      // Defined after pub get
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => TodoProvider()),
      ],
      child: const EventVenueApp(),
    ),
  );
}

class EventVenueApp extends StatelessWidget {
  const EventVenueApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      // Defined after pub get
      builder: (context, themeProvider, child) {
        final baseTheme = ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
          fontFamily: 'Poppins',
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              visualDensity: VisualDensity.compact,
            ),
          ),
        );
        return MaterialApp(
          title: 'Event Venue Booking',
          theme: baseTheme, // Light theme
          darkTheme:
              baseTheme.copyWith(brightness: Brightness.dark), // Dark theme
          themeMode:
              themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          initialRoute: '/app',
          routes: {
            '/': (context) => LoginScreen(), // login still available if needed
            '/home': (context) => const MainShell(),
            '/app': (context) => const MainShell(),
            '/about': (context) => AboutScreen(),
            '/contact': (context) => ContactScreen(),
            '/booking': (context) => VenueBookingScreen(),
            '/documents': (context) => DocumentTrackerScreen(),
            '/profile': (context) => ProfileScreen(),
            '/settings': (context) => SettingsScreen(),
            '/register': (context) => RegistrationScreen(),
            '/cart': (context) => CartScreen(),
            '/tasks': (context) => TodoScreen(),
            '/gallery': (context) => GalleryScreen(),
            '/media': (context) => MediaScreen(),
          },
        );
      },
    );
  }
}
