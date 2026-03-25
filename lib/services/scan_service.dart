import '../models/scan_result.dart';
import '../models/event.dart';
import '../config/api_config.dart';
import 'api_service.dart';

class ScanService {
  final ApiService _api;
  final List<ScanResult> _history = [];

  ScanService(this._api);

  List<ScanResult> get history => List.unmodifiable(_history);

  Future<ScanResult> scanTicket(String qrCode, {String? eventId}) async {
    final response = await _api.post(ApiConfig.scanTicketEndpoint, data: {
      'qrCode': qrCode,
      'eventId': eventId,
    });

    final result = ScanResult.fromJson(response.data['data']);
    _history.insert(0, result);
    return result;
  }

  Future<ScanResult> scanCredit(String qrCode, {double? amount, String? eventId}) async {
    final response = await _api.post(ApiConfig.scanCreditEndpoint, data: {
      'qrCode': qrCode,
      'amount': amount,
      'eventId': eventId,
    });

    final result = ScanResult.fromJson(response.data['data']);
    _history.insert(0, result);
    return result;
  }

  Future<List<Event>> getEvents() async {
    final response = await _api.get(ApiConfig.eventsEndpoint);
    final List<dynamic> data = response.data['data'];
    return data.map((e) => Event.fromJson(e)).toList();
  }

  void clearHistory() {
    _history.clear();
  }
}
