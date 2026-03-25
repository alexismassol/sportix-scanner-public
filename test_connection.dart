import 'lib/services/api_service.dart';
import 'lib/services/auth_service.dart';
import 'lib/services/scan_service.dart';
import 'lib/config/api_config.dart';

void main() async {
  print('🧪 Test connexion Flutter ↔ Backend');
  print('=====================================');

  // Test API Service
  final api = ApiService();
  api.updateBaseUrl('192.168.5.178', port: '3000');
  
  print('🌐 API Base URL: ${ApiConfig.baseUrl}');
  print('📡 Test de connexion...');
  
  try {
    final isConnected = await api.testConnection();
    print('✅ Connexion backend: ${isConnected ? "OK" : "KO"}');
    
    if (isConnected) {
      // Test Login
      print('\n🔐 Test login club@sport-ix.com...');
      final auth = AuthService(api);
      
      try {
        final result = await auth.login('club@sport-ix.com', 'Club2024!');
        print('✅ Login OK: ${result.user.email}');
        print('🎫 Token: ${result.token.substring(0, 20)}...');
        
        // Test Scan
        print('\n📱 Test scan ticket...');
        final scanService = ScanService(api);
        final scanResult = await scanService.scanTicket('Q1JLR1RJQ0tFVDIwMjZfRVZFTlRfUExBTk5FRA==');
        print('✅ Scan OK: ${scanResult.status} - ${scanResult.message}');
        
      } catch (e) {
        print('❌ Erreur login/scan: $e');
      }
    }
  } catch (e) {
    print('❌ Erreur connexion: $e');
  }
  
  print('\n🎯 Test terminé !');
}
