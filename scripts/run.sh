#!/bin/bash
# ============================================
# Run Script — Sportix Scanner Public Demo
# Lance l'application Flutter avec l'IP du backend
# ============================================

set -e

echo "📱 Sportix Scanner — Lancement"
echo "=============================="

if [ -z "$1" ]; then
  echo ""
  echo "Usage : ./scripts/run.sh <IP_DU_BACKEND>"
  echo ""
  echo "Exemple : ./scripts/run.sh 192.168.1.15"
  echo ""
  echo "Trouvez votre IP :"
  echo "  macOS  : ifconfig | grep 'inet ' | grep -v 127.0.0.1"
  echo "  Linux  : hostname -I"
  echo "  Windows: ipconfig"
  exit 1
fi

API_HOST=$1
API_PORT=${2:-3000}

echo ""
echo "🔗 Backend : http://$API_HOST:$API_PORT"
echo ""

flutter run --dart-define=API_HOST=$API_HOST --dart-define=API_PORT=$API_PORT
