# Sportix Scanner — Public Demo

**Application mobile Flutter** de scan de billets et crédits pour la plateforme **Sport IX** — développée par **Alexis MASSOL**.

> Scanner QR code en temps réel connecté au backend Sportix pour la validation d'entrées et les paiements buvette.

> **AVERTISSEMENT** : Ce projet est une **version de démonstration** destinée à un usage éducatif et portfolio uniquement. Il n'est **PAS conçu pour la production** : il ne contient pas les optimisations de performance, la sécurité avancée (chiffrement, certificate pinning...), ni le mode hors-ligne complet de l'application Sport IX Scanner originale. Voir [LICENSE](./LICENSE) pour les conditions d'utilisation.

---

## Présentation

Sportix Scanner est l'application mobile compagnon de la plateforme Sport IX. Elle permet aux clubs sportifs de :
- **Scanner les billets** des spectateurs à l'entrée des événements
- **Scanner les crédits** pour les paiements à la buvette
- **Consulter l'historique** des scans en temps réel
- Fonctionner **hors-ligne** avec synchronisation automatique

Ce dépôt est une **version démo publique** qui fonctionne avec le backend [sportix-public](https://github.com/alexismassol/sportix-public).

---

## Démarrage rapide

### Prérequis
- **Flutter** ≥ 3.6.0
- **Dart** ≥ 3.6.0
- Le backend **sportix-public** doit tourner sur votre réseau local

### Installation

```bash
# Cloner le dépôt
git clone https://github.com/alexismassol/sportix-scanner-public.git
cd sportix-scanner-public

# Installer les dépendances
flutter pub get
```

### Configuration du backend

L'application doit pointer vers l'adresse IP de votre PC sur le réseau local (là où tourne le backend sportix-public).

1. Démarrez le backend sportix-public sur votre PC :
   ```bash
   cd sportix-public && npm start
   # → Backend accessible sur http://VOTRE_IP:3000
   ```

2. L'adresse IP de votre PC s'affiche automatiquement au lancement du backend :
   ```
      Sportix Public API
      → http://localhost:3000
      → http://192.168.1.XX:3000  (pour Flutter / mobile)
   ```
   Vous pouvez aussi la trouver manuellement :
   ```bash
   # macOS
   ifconfig | grep "inet " | grep -v 127.0.0.1
   # Linux
   hostname -I
   # Windows
   ipconfig
   ```

3. Lancez l'application Flutter avec votre IP :
   ```bash
   flutter run --dart-define=API_HOST=192.168.1.XX
   ```

### Lancement rapide

```bash
# Avec le script fourni
./scripts/run.sh 192.168.1.XX

# Ou directement
flutter run --dart-define=API_HOST=192.168.1.XX
```

---

## Compte démo

| Rôle | Email | Mot de passe |
|------|-------|-------------|
| Club | `club@sport-ix.com` | `Club2024!` |

> Connectez-vous avec le compte club pour accéder aux fonctions de scan.

---

## Structure du projet

```
sportix-scanner-public/
├── lib/              # Code source Dart
│   ├── config/       # Configuration API + thème
│   ├── models/       # Modèles de données
│   ├── services/     # Services (API, auth, scan)
│   ├── providers/    # State management (Riverpod)
│   ├── screens/      # Écrans de l'application
│   └── widgets/      # Widgets réutilisables
├── test/             # Tests unitaires, widget, intégration & V&V
├── assets/           # Polices Poppins
└── docs/             # Spécifications
```

Voir [ARBORESCENCE.md](./ARBORESCENCE.md) pour l'arborescence complète.

---

## Tests

```bash
# Tests unitaires & widget
flutter test

# Tests V&V (validation & vérification)
flutter test test/vv/

# Tests d'intégration (nécessite un émulateur/device)
flutter test test/integration/

# Lint / analyse statique
dart analyze
```

---

## Connexion avec le backend

L'application Flutter communique avec le backend `sportix-public` via :
- **POST** `/api/auth/login` — Authentification
- **GET** `/api/auth/me` — Récupération du profil connecté
- **GET** `/api/events` — Liste des événements
- **POST** `/api/scan/ticket` — Validation d'un billet
- **POST** `/api/scan/credit` — Débit de crédits buvette
- **GET** `/api/stats` — Statistiques globales (accueil scanner)

Le flux complet :
1. Login avec le compte club
2. Sélection d'un événement
3. Scan du QR code (simulation via boutons de scénarios démo)
4. Envoi au backend → réponse (valide/invalide/déjà scanné)
5. Affichage du résultat avec feedback visuel et haptique

---

## Design

Le thème reprend les tokens Sport IX :
- **Fond sombre** : #0A0E1A
- **Accent rouge** : #FF2D55
- **Accent orange** : #FF6B35
- **Typographie** : Poppins
- **Effets** : Glass morphism, gradients

---

## Technologies

- **Flutter 3.6+** / **Dart 3.6+**
- **Riverpod** (state management)
- **Dio** (HTTP client)

---

## Documentation

- [Spécification Technique](./docs/SPEC_TECHNIQUE.md)
- [Spécification Fonctionnelle](./docs/SPEC_FONCTIONNELLE.md)
- [Arborescence](./ARBORESCENCE.md)

---

## Auteur

**Alexis MASSOL**
- Développeur Full Stack & Mobile
- Créateur de la plateforme Sport IX

---

## Licence

Ce projet est la propriété exclusive d'**Alexis MASSOL**. Aucune utilisation commerciale n'est autorisée.
Voir [LICENSE](./LICENSE) pour les détails complets.
