# Arborescence - Sportix Scanner Public Demo

```
sportix-scanner-public/
│
├── README.md                          # Documentation principale
├── ARBORESCENCE.md                    # Ce fichier
├── LICENSE                            # Licence propriétaire (Alexis MASSOL)
├── .gitignore                         # Fichiers ignorés par Git
├── pubspec.yaml                       # Dépendances Flutter (flutter, flutter_riverpod, dio)
├── analysis_options.yaml              # Règles de lint Dart
│
├── docs/                              # Documentation
│   ├── SPEC_TECHNIQUE.md              # Spécification technique complète
│   └── SPEC_FONCTIONNELLE.md          # Spécification fonctionnelle complète
│
├── scripts/
│   └── run.sh                         # Script de lancement avec config IP
│
├── lib/                               # Code source Dart
│   ├── main.dart                      # Point d'entrée
│   ├── app.dart                       # MaterialApp + routing
│   ├── config/
│   │   ├── api_config.dart            # URL backend configurable (--dart-define=API_HOST)
│   │   └── theme.dart                 # Thème Sport IX (couleurs, typo, glass)
│   ├── models/
│   │   ├── user.dart                  # Modèle utilisateur
│   │   ├── event.dart                 # Modèle événement
│   │   └── scan_result.dart           # Modèle résultat de scan
│   ├── services/
│   │   ├── api_service.dart           # Client HTTP Dio → backend
│   │   ├── auth_service.dart          # Authentification (login/logout)
│   │   └── scan_service.dart          # Envoi des scans au backend
│   ├── providers/
│   │   └── auth_provider.dart         # Riverpod state management
│   ├── screens/
│   │   ├── login_screen.dart          # Écran de connexion
│   │   ├── home_screen.dart           # Accueil (stats + navigation)
│   │   ├── event_select_screen.dart   # Sélection d'événement
│   │   ├── ticket_scanner_screen.dart # Scanner de billets (simulation démo)
│   │   ├── credit_scanner_screen.dart # Scanner de crédits (simulation démo)
│   │   ├── scan_history_screen.dart   # Historique des scans
│   │   └── settings_screen.dart       # Paramètres (URL serveur)
│   └── widgets/
│       └── scan_result_card.dart      # Card résultat de scan
│
├── test/                              # Tests
│   ├── unit/
│   │   ├── auth_provider_test.dart    # Tests unitaires auth provider
│   │   └── models_test.dart           # Tests unitaires modèles
│   ├── widget/
│   │   ├── login_screen_test.dart     # Tests widget login
│   │   └── scan_result_card_test.dart # Tests widget scan result card
│   ├── integration/
│   │   └── full_flow_test.dart        # Test d'intégration complet
│   └── vv/
│       └── cross_flow_vv_test.dart    # Tests V&V (validation & vérification)
```
