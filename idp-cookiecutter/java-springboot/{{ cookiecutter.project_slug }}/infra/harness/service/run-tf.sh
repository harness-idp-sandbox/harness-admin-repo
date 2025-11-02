#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

# --- Sanity
command -v terraform >/dev/null || { echo "❌ terraform not found"; exit 1; }
[[ -f main.tf && -f variables.tf && -f terraform.tfvars ]] || {
  echo "❌ Missing Terraform files"; exit 2; }

# --- Provider auth via ENV (no secrets in tfvars)
: "${HARNESS_ACCOUNT_ID:?set HARNESS_ACCOUNT_ID}"
: "${HARNESS_PLATFORM_API_KEY:?set HARNESS_PLATFORM_API_KEY}"
# Optional: let org/project override tfvars if you pass them via env
export HARNESS_ORG_ID="${HARNESS_ORG_ID:-}"
export HARNESS_PROJECT_ID="${HARNESS_PROJECT_ID:-}"

# --- Optional overrides from env (e.g., pipeline sequence tags)
APPLY_ARGS=()
[[ -n "${IMAGE_TAG:-}"  ]] && APPLY_ARGS+=(-var "image_tag=${IMAGE_TAG}")
[[ -n "${IMAGE_REPO:-}" ]] && APPLY_ARGS+=(-var "image_repo=${IMAGE_REPO}")

terraform init -input=false
terraform apply -auto-approve -input=false "${APPLY_ARGS[@]}"

echo "✅ Harness Service registered/updated."
