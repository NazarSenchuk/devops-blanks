#!/bin/bash
DEST=${1:-new-project}
REPO_URL=https://github.com/NazarSenchuk/devops-blanks.git

mkdir "$DEST"
cd "$DEST"
git init
git remote add origin "$REPO_URL"
git config core.sparseCheckout true
echo "kubernetes/template/*" >> .git/info/sparse-checkout
git pull origin main


mv kubernetes/template/* . 2>/dev/null
rmdir kubernetes/template kubernetes 2>/dev/null

echo "Template cloned into $DEST"