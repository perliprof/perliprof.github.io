#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEPLOY_DIR="$HOME/.hub-deploy"

if [ ! -d "$DEPLOY_DIR/.git" ]; then
  echo "Klonuojama..."
  git clone https://github.com/perliprof/perliprof.github.io.git "$DEPLOY_DIR"
fi

cd "$DEPLOY_DIR"
git pull --ff-only --quiet

cp "$SCRIPT_DIR/index.html" .
cp "$SCRIPT_DIR/manifest.json" .
cp "$SCRIPT_DIR/logo.png" .
touch .nojekyll

git add index.html manifest.json logo.png .nojekyll

if git diff --cached --quiet; then
  echo "Nera pakeitimu — puslapis jau atnaujintas."
  exit 0
fi

git commit -m "Atnaujinimas: $(date '+%Y-%m-%d %H:%M')"
git push origin main

echo ""
echo "Puslapis atnaujintas!"
echo "https://perliprof.github.io/"
