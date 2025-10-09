import 'package:flutter/material.dart';
import '../services/booking_service.dart';

class VenueBookingScreen extends StatefulWidget {
  const VenueBookingScreen({Key? key}) : super(key: key);

  @override
  _VenueBookingScreenState createState() => _VenueBookingScreenState();
}

class _VenueBookingScreenState extends State<VenueBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _specialRequestCtrl = TextEditingController();
  final _bookingService = BookingService();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _termsAccepted = false;
  bool _emailNotifications = true;

  final List<String> _venues = [
    'Grand Hall',
    'Conference Room',
    'Outdoor Garden'
  ];
  String? _selectedVenue;

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (date != null) setState(() => _selectedDate = date);
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay(hour: 18, minute: 0),
    );
    if (time != null) setState(() => _selectedTime = time);
  }

  void _submitBooking() {
    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You must accept the terms and conditions')));
      return;
    }
    if (_formKey.currentState!.validate() &&
        _selectedDate != null &&
        _selectedTime != null &&
        _selectedVenue != null) {
      final booking = {
        'venue': _selectedVenue!,
        'date': _selectedDate!.toLocal().toString().split(' ')[0],
        'time': _selectedTime!.format(context),
        'requests': _specialRequestCtrl.text,
        'emailNotifications': _emailNotifications,
      };

      _bookingService.addBooking(booking);

      setState(() {
        _selectedDate = null;
        _selectedTime = null;
        _selectedVenue = null;
        _specialRequestCtrl.clear();
        _termsAccepted = false;
        _emailNotifications = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking submitted successfully')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please complete all fields')));
    }
  }

  @override
  void dispose() {
    _specialRequestCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book a Venue')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Select Venue'),
                items: _venues
                    .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                    .toList(),
                value: _selectedVenue,
                onChanged: (val) => setState(() => _selectedVenue = val),
                validator: (val) =>
                    val == null ? 'Please select a venue' : null,
              ),
            ),
            ListTile(
              title: Text(_selectedDate == null
                  ? 'Select Date'
                  : 'Date: ${_selectedDate!.toLocal()}'.split(' ')[0]),
              trailing: Icon(Icons.calendar_today),
              onTap: _pickDate,
            ),
            ListTile(
              title: Text(_selectedTime == null
                  ? 'Select Time'
                  : 'Time: ${_selectedTime!.format(context)}'),
              trailing: Icon(Icons.access_time),
              onTap: _pickTime,
            ),
            TextField(
              controller: _specialRequestCtrl,
              decoration: InputDecoration(
                labelText: 'Special Requests (optional)',
              ),
              maxLines: 2,
            ),
            SwitchListTile(
              title: Text('Receive Email Notifications'),
              value: _emailNotifications,
              onChanged: (val) => setState(() => _emailNotifications = val),
            ),
            CheckboxListTile(
              title: Text('I accept the terms and conditions'),
              value: _termsAccepted,
              onChanged: (val) => setState(() => _termsAccepted = val ?? false),
            ),
            ElevatedButton(
                onPressed: _submitBooking, child: Text('Submit Booking')),
            SizedBox(height: 20),
            Expanded(
              child: _bookingService.bookings.isEmpty
                  ? Text('No bookings yet')
                  : ListView.builder(
                      itemCount: _bookingService.bookings.length,
                      itemBuilder: (context, index) {
                        final b = _bookingService.bookings[index];
                        return Card(
                          child: ListTile(
                            title: Text(
                                '${b['venue']} on ${b['date']} at ${b['time']}'),
                            subtitle: Text(
                                'Requests: ${b['requests']?.isEmpty ?? true ? "None" : b['requests']}\nEmail notifications: ${b['emailNotifications'] ? "Enabled" : "Disabled"}'),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
