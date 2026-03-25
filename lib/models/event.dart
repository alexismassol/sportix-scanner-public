class Event {
  final String id;
  final String title;
  final String sportType;
  final String date;
  final String location;
  final String clubName;
  final int ticketsSold;
  final int maxCapacity;
  final double price;
  final String status;

  Event({
    required this.id,
    required this.title,
    required this.sportType,
    required this.date,
    required this.location,
    required this.clubName,
    required this.ticketsSold,
    required this.maxCapacity,
    required this.price,
    required this.status,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as String,
      title: json['title'] as String,
      sportType: json['sportType'] as String,
      date: json['date'] as String,
      location: json['location'] as String,
      clubName: json['clubName'] as String,
      ticketsSold: json['ticketsSold'] as int,
      maxCapacity: json['maxCapacity'] as int,
      price: (json['price'] as num).toDouble(),
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'sportType': sportType,
      'date': date,
      'location': location,
      'clubName': clubName,
      'ticketsSold': ticketsSold,
      'maxCapacity': maxCapacity,
      'price': price,
      'status': status,
    };
  }

  int get remainingCapacity => maxCapacity - ticketsSold;
  double get fillPercentage => ticketsSold / maxCapacity;
}
