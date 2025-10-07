import 'package:flutter/material.dart';
import 'venue_booking_screen.dart';
import 'document_tracker_screen.dart';

class HomeScreen extends StatelessWidget {
  void _goToBooking(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => VenueBookingScreen()));
  }

  void _goToDocumentTracker(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => DocumentTrackerScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Venue Booking'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: ElevatedButton(
                onPressed: () => _goToBooking(context),
                child: Text('Book a Venue'),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () => _goToDocumentTracker(context),
                child: Text('View Booking Documents'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
