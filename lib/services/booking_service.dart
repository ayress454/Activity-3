class BookingService {
  // Singleton pattern
  static final BookingService _instance = BookingService._internal();

  factory BookingService() {
    return _instance;
  }

  BookingService._internal();

  final List<Map<String, dynamic>> _bookings = [];

  List<Map<String, dynamic>> get bookings => _bookings;

  void addBooking(Map<String, dynamic> booking) {
    _bookings.add(booking);
  }

  void clearBookings() {
    _bookings.clear();
  }
}
