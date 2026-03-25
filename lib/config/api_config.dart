class ApiConfig {
  static const _host = String.fromEnvironment('API_HOST', defaultValue: '192.168.1.15');
  static const _port = String.fromEnvironment('API_PORT', defaultValue: '3000');

  static String get baseUrl => 'http://$_host:$_port/api';

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);

  // Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String meEndpoint = '/auth/me';
  static const String eventsEndpoint = '/events';
  static const String scanTicketEndpoint = '/scan/ticket';
  static const String scanCreditEndpoint = '/scan/credit';
  static const String statsEndpoint = '/stats';
}
