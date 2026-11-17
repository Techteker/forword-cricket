#!/usr/bin/env bash
set -euo pipefail
export CI=true

FLUTTER_DIR="${HOME}/flutter"
if [ ! -x "${FLUTTER_DIR}/bin/flutter" ]; then
  git clone --depth 1 --branch stable https://github.com/flutter/flutter.git "${FLUTTER_DIR}"
fi
export PATH="${FLUTTER_DIR}/bin:${PATH}"
flutter config --no-analytics
flutter create --platforms=web --overwrite --no-pub . --project-name forword_cricket
flutter pub get
flutter build web --release \
  --dart-define="APPWRITE_ENDPOINT=${APPWRITE_ENDPOINT:-https://cloud.appwrite.io/v1}" \
  --dart-define="APPWRITE_PROJECT_ID=${APPWRITE_PROJECT_ID:-}" \
  --dart-define="APPWRITE_DATABASE_ID=${APPWRITE_DATABASE_ID:-}"
