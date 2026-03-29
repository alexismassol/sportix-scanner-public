# Spécification Technique - Sportix Scanner Public Demo

**Version** : 1.0.0
**Auteur** : Alexis MASSOL
**Date** : Mars 2026

---

## 1. Vue d'ensemble

Sportix Scanner est l'application mobile Flutter compagnon de Sport IX. Elle permet aux clubs sportifs de scanner les billets et crédits des spectateurs lors d'événements sportifs.

---

## 2. Architecture

### 2.1 Stack technique

| Composant | Technologie |
|-----------|------------|
| Framework | Flutter 3.6+ / Dart 3.6+ |
| State management | Riverpod 2.6 |
| HTTP client | Dio 5.7 |

### 2.2 Architecture en couches

```
┌─────────────────────────────────────────┐
│              Screens (UI)                │
│  login, home, scanner, history, settings │
├─────────────────────────────────────────┤
│            Providers (State)             │
│         Riverpod (auth_provider)         │
├─────────────────────────────────────────┤
│            Services (Logic)              │
│    api_service, auth_service, scan       │
├─────────────────────────────────────────┤
│            Models (Data)                 │
│      user, event, scan_result            │
├─────────────────────────────────────────┤
│            Config                        │
│       api_config, theme                  │
└─────────────────────────────────────────┘
         │
         ▼ HTTP (Dio)
┌─────────────────────────────────────────┐
│     Backend sportix-public (port 3000)   │
└─────────────────────────────────────────┘
```

---

## 3. Configuration réseau

### 3.1 API Config

L'URL du backend est configurable via `--dart-define` au build time :

```dart
class ApiConfig {
  static const _host = String.fromEnvironment('API_HOST', defaultValue: '192.168.1.15');
  static const _port = String.fromEnvironment('API_PORT', defaultValue: '3000');
  static String get baseUrl => 'http://$_host:$_port/api';
}
```

### 3.2 Lancement

```bash
flutter run --dart-define=API_HOST=192.168.1.XX
```

---

## 4. Modèles de données

### 4.1 User

```dart
class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String role;        // 'spectator' | 'club'
  final String? clubName;
}
```

### 4.2 Event

```dart
class Event {
  final String id;
  final String title;
  final String sportType;
  final String date;        // ISO 8601 string (ex: "2026-04-15T20:00:00Z")
  final String location;
  final String clubName;
  final int ticketsSold;
  final int maxCapacity;
  final double price;
  final String status;      // 'upcoming' | 'live' | 'completed'
}
```

### 4.3 ScanResult

```dart
class ScanResult {
  final String status;      // 'valid' | 'already_scanned' | 'refunded' | 'invalid' | 'insufficient'
  final String message;
  final String? ticketId;
  final String? holderName;
  final String? seatInfo;
  final String? scannedAt;
  final double? previousBalance;
  final double? newBalance;
  final double? amount;
  final DateTime timestamp; // généré localement au moment du scan
}
```

---

## 5. Services

### 5.1 ApiService

Client HTTP centralisé (Dio) :
- Base URL configurable via `--dart-define=API_HOST`
- Interceptor pour le token JWT
- Timeout : 10 secondes
- Gestion d'erreurs centralisée

### 5.2 AuthService

- `login(email, password)` → User + token
- `logout()` → supprime le token
- `isAuthenticated` → bool
- Token géré en mémoire via Riverpod

### 5.3 ScanService

- `scanTicket(qrCode, {eventId})` → ScanResult
- `scanCredit(qrCode, {debitAmount, eventId})` → ScanResult
- Historique en mémoire des scans de la session
- Scénarios de démonstration intégrés (sans caméra)

---

## 6. Screens

| Screen | Route | Description |
|--------|-------|-------------|
| LoginScreen | `/login` | Connexion (email + mot de passe) |
| HomeScreen | `/home` | Accueil avec stats et navigation |
| EventSelectScreen | `/events` | Sélection d'événement pour le scan |
| TicketScannerScreen | `/scan/ticket` | Scanner de billets (simulation démo) |
| CreditScannerScreen | `/scan/credit` | Scanner de crédits (simulation démo) |
| ScanHistoryScreen | `/history` | Historique des scans |
| SettingsScreen | `/settings` | Configuration (URL serveur) |

---

## 7. Thème Sport IX

### 7.1 Couleurs

```dart
class SportixColors {
  static const bgPrimary = Color(0xFF0A0E1A);
  static const bgSecondary = Color(0xFF111827);
  static const accentPrimary = Color(0xFFFF2D55);
  static const accentSecondary = Color(0xFFFF6B35);
  static const success = Color(0xFF00E676);
  static const warning = Color(0xFFFFAB40);
  static const error = Color(0xFFFF5252);
}
```

### 7.2 Typographie

- Police : Poppins (Regular, Medium, SemiBold, Bold)
- Tailles : cohérentes avec les tokens CSS du web

### 7.3 Glass Morphism

```dart
class SportixGlass {
  static BoxDecoration get card => BoxDecoration(
    color: Colors.white.withValues(alpha: 0.10),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
  );
}
```

---

## 8. Tests

### 8.1 Tests unitaires (`test/`)

- **Models** : sérialisation/désérialisation JSON
- **Services** : mock des appels HTTP (Dio), vérification des retours
- **Providers** : vérification des états Riverpod

### 8.2 Tests widget (`test/`)

- **Widgets** : rendu, interactions, états visuels
- **Screens** : navigation, formulaires

### 8.3 Tests d'intégration (`test/integration/`)

- Parcours complet : login → sélection event → scan → résultat

---

## 9. Permissions

| Permission | Usage |
|-----------|-------|
| Internet | Communication avec le backend |

> Cette version démo simule le scan via des boutons de scénarios. Aucune permission caméra requise.

---

## 10. Compatibilité

- **iOS** : 12.0+
- **Android** : API 21+ (Android 5.0)
- **Flutter** : 3.6.0+
- **Dart** : 3.6.0+
