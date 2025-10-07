import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(EventVenueApp());
}

class EventVenueApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Venue Booking',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: LoginScreen(),
    );
  }
}
