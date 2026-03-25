# Spécification Fonctionnelle — Sportix Scanner Public Demo

**Version** : 1.0.0
**Auteur** : Alexis MASSOL
**Date** : Mars 2026

---

## 1. Objectif

L'application Sportix Scanner permet aux clubs sportifs de :
- Valider les entrées des spectateurs en scannant leurs billets QR code
- Gérer les paiements buvette via scan de crédits
- Consulter l'historique et les statistiques de scan en temps réel

---

## 2. Compte démo

| Email | Mot de passe | Rôle |
|-------|-------------|------|
| `club@sport-ix.com` | `Club2024!` | Club |

---

## 3. Écrans et parcours

### 3.1 Écran de connexion

- Champs : email + mot de passe
- Validation en temps réel
- Bouton "Se connecter"
- Message d'erreur si identifiants incorrects
- Redirection vers l'accueil après connexion

### 3.2 Écran d'accueil

Après connexion, l'utilisateur voit :
- **Nom du club** connecté
- **Statistiques rapides** : scans aujourd'hui, billets validés, crédits débités
- **Boutons d'action** :
  - Scanner un billet
  - Scanner un crédit
  - Voir l'historique
- **Liste des événements** du jour

### 3.3 Sélection d'événement

- Liste des événements disponibles (depuis l'API)
- Chaque événement affiche : titre, sport, date, lieu, places restantes
- Sélection d'un événement → accès au scanner

### 3.4 Scanner de billets

- **Interface de simulation** avec boutons de scénarios démo
- Après sélection d'un scénario :
  - ✅ **Valide** : fond vert, nom du spectateur, info siège, vibration courte
  - ⚠️ **Déjà scanné** : fond orange, heure du premier scan, vibration double
  - ❌ **Remboursé** : fond rouge, message explicatif
  - ❌ **Invalide** : fond rouge, "QR code non reconnu"
- **Compteur** en haut : X billets scannés / Y total
- Bouton retour vers la sélection d'événement

### 3.5 Scanner de crédits

- Même interface de simulation que le scanner billets
- Affiche le **solde** du spectateur avant et après
- **Montant** à débiter (configurable)
- Résultats :
  - ✅ **Succès** : solde débité, nouveau solde affiché
  - ❌ **Solde insuffisant** : message d'erreur
  - ❌ **QR invalide** : message d'erreur

### 3.6 Historique des scans

- Liste chronologique des derniers scans
- Chaque entrée affiche : heure, type (billet/crédit), résultat, nom du spectateur
- Filtres : type de scan, résultat (valide/invalide)
- Recherche par nom

### 3.7 Paramètres

- **URL du serveur** : champ texte pour modifier l'adresse IP du backend
- **Bouton test** : vérifier la connexion au serveur
- **Déconnexion** : retour à l'écran de login

---

## 4. Flux de scan

```
Utilisateur ouvre le scanner
        │
        ▼
  Sélection d'un scénario démo
        │
        ▼
  QR code simulé
        │
        ▼
  Envoi au backend (POST /api/scan/ticket ou /credit)
        │
        ├── 200 OK + valid ──────► Écran vert + vibration ✅
        ├── 200 OK + already_scanned ► Écran orange + vibration ⚠️
        ├── 200 OK + refunded ───► Écran rouge ❌
        ├── 200 OK + invalid ────► Écran rouge ❌
        └── Erreur réseau ───────► Message "Hors ligne" + retry
```

---

## 5. Interaction avec le site web

L'application Flutter et le site web `sportix-public` partagent le même backend :

1. Sur le site web (`/demo/scan-billet`), des QR codes de test sont générés
2. L'utilisateur scanne ces QR codes avec l'app Flutter
3. Le backend valide le scan et retourne le résultat
4. Les deux interfaces sont synchronisées

---

## 6. Gestion hors-ligne

> Cette version démo ne gère pas le mode hors-ligne. En cas d'erreur réseau, un message d'erreur s'affiche et un résultat de démonstration local est retourné pour permettre la présentation.
- Si le réseau est indisponible, un message d'erreur est affiché
- Un résultat de démonstration local est retourné en fallback

---

## 7. UX/UI

### 7.1 Principes

- **Rapidité** : scan → résultat en < 2 secondes
- **Clarté** : résultat immédiatement visible (couleur + icône + texte)
- **Feedback haptique** : vibration différente selon le résultat
- **Mode sombre** : thème Sport IX (fond #0A0E1A)

### 7.2 Animations

- Transition fluide entre les écrans
- Effet pulse sur le résultat du scan
- Animation de chargement pendant la vérification
