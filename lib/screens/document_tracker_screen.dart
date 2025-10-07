import 'package:flutter/material.dart';
import 'booking_service.dart';

class DocumentTrackerScreen extends StatefulWidget {
  @override
  _DocumentTrackerScreenState createState() => _DocumentTrackerScreenState();
}

class _DocumentTrackerScreenState extends State<DocumentTrackerScreen> {
  final _bookingService = BookingService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking Documents')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: _bookingService.bookings.isEmpty
            ? Center(child: Text('No bookings yet'))
            : ListView.builder(
                itemCount: _bookingService.bookings.length,
                itemBuilder: (context, index) {
                  final booking = _bookingService.bookings[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(
                        '${booking['venue']}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4),
                          Text('Date: ${booking['date']}'),
                          Text('Time: ${booking['time']}'),
                          if (booking['requests']?.isNotEmpty ?? false)
                            Text('Requests: ${booking['requests']}'),
                          Text(
                            'Email Notifications: ${booking['emailNotifications'] ? "Enabled" : "Disabled"}',
                            style: TextStyle(
                              color: booking['emailNotifications']
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      trailing: Icon(Icons.description, color: Colors.blue),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
