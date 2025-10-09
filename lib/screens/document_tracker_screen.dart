import 'package:flutter/material.dart';
import '../services/booking_service.dart';

class DocumentTrackerScreen extends StatefulWidget {
  const DocumentTrackerScreen({Key? key}) : super(key: key);

  @override
  _DocumentTrackerScreenState createState() => _DocumentTrackerScreenState();
}

class _DocumentTrackerScreenState extends State<DocumentTrackerScreen>
    with SingleTickerProviderStateMixin {
  final _bookingService = BookingService();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Documents'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.all_inbox), text: 'All'),
            Tab(icon: Icon(Icons.pending), text: 'Pending'),
            Tab(icon: Icon(Icons.check_circle), text: 'Confirmed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBookingList('all'),
          _buildBookingList('pending'),
          _buildBookingList('confirmed'),
        ],
      ),
    );
  }

  Widget _buildBookingList(String filter) {
    return Padding(
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
                        Text(
                          'Status: ${filter == 'confirmed' ? 'Confirmed' : 'Pending'}',
                          style: TextStyle(
                            color: filter == 'confirmed'
                                ? Colors.green
                                : Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    trailing: Icon(Icons.description, color: Colors.blue),
                  ),
                );
              },
            ),
    );
  }
}
