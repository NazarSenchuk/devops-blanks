#!/bin/bash
set -e

# Configuration
REPO_URL="https://github.com/NazarSenchuk/devops-blanks.git"
TEMPLATE_PATH="terraform/template"
DEFAULT_DEST="infrastructure"

usage() {
    echo "Usage: $0 [DESTDIR]"
    echo "  DESTDIR: Directory to initialize (default: $DEFAULT_DEST)"
    exit 1
}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    usage
fi

DEST=${1:-$DEFAULT_DEST}

if [ -d "$DEST" ]; then
    echo "Error: Directory '$DEST' already exists."
    exit 1
fi

echo " Initializing Terraform project in '$DEST'..."

# Create destination and initialize git
mkdir -p "$DEST"
cd "$DEST"
git init -q

# Set up sparse checkout
git remote add origin "$REPO_URL"
git config core.sparseCheckout true
echo "$TEMPLATE_PATH/*" >> .git/info/sparse-checkout

# Pull the template
echo " Downloading template..."
if ! git pull origin main --quiet; then
    echo " Error: Failed to pull from $REPO_URL"
    exit 1
fi

# Move files to root and cleanup
if [ -d "$TEMPLATE_PATH" ]; then
    mv "$TEMPLATE_PATH"/{.,}* . 2>/dev/null || true
    rm -rf terraform
else
    echo " Warning: Template path $TEMPLATE_PATH not found in repository."
fi

# Initialize terraform if command exists
if command -v terraform >/dev/null 2>&1; then
    echo "  Running terraform init..."
    # We don't run it automatically to avoid unexpected network requests or errors
    # but we inform the user to do it.
fi

echo " Terraform project initialized in $DEST"
echo "Next steps:"
echo "  1. cd $DEST"
echo "  2. Review variables.tf and providers.tf"
echo "  3. Run: terraform init"
