#!/usr/bin/env bash
# Deploy Halon config: inject secrets, pack, copy, restart services.
set -euo pipefail

SECRETS_FILE="$(dirname "$0")/secrets.env"

# ── 1. Load secrets ──────────────────────────────────────────────────────────
if [[ ! -f "$SECRETS_FILE" ]]; then
  echo "Error: secrets file not found at $SECRETS_FILE" >&2
  echo "Copy secrets.env.example to secrets.env in the project root and fill in real values." >&2
  exit 1
fi

# Export all variables defined in the secrets file
set -a
# shellcheck source=/etc/halon/secrets.env
source "$SECRETS_FILE"
set +a

# ── 2. Validate required variables ───────────────────────────────────────────
required_vars=(
  MSUI_DB_PASSWORD
  MSUI_ADMIN_PASSWORD
  ELASTIC_USERNAME
  ELASTIC_PASSWORD
  SMTPD_ELASTIC_BASIC_AUTH
  WEB_PRIVATE_KEY
  WEB_ADMIN_PASSWORD
  WEB_OIDC_CLIENT_SECRET
)

missing=()
for var in "${required_vars[@]}"; do
  [[ -z "${!var:-}" ]] && missing+=("$var")
done

if [[ ${#missing[@]} -gt 0 ]]; then
  echo "Error: the following variables are not set in $SECRETS_FILE:" >&2
  printf '  %s\n' "${missing[@]}" >&2
  exit 1
fi

# Preserve YAML indentation for multiline private key content by detecting
# indentation from the WEB_PRIVATE_KEY_INDENTED placeholder line in web.yaml.
web_key_indent="$(awk '/\$\{WEB_PRIVATE_KEY_INDENTED\}/{match($0,/^[[:space:]]*/); print substr($0,1,RLENGTH); exit}' src/config/web.yaml)"
if [[ -z "$web_key_indent" ]]; then
  echo "Error: could not detect WEB_PRIVATE_KEY_INDENTED indentation in src/config/web.yaml" >&2
  exit 1
fi
WEB_PRIVATE_KEY_INDENTED="${WEB_PRIVATE_KEY//$'\n'/$'\n'"$web_key_indent"}"
export WEB_PRIVATE_KEY_INDENTED

# ── 3. Pack config ───────────────────────────────────────────────────────────
halonconfig

# ── 4. Overwrite secret-bearing configs in dist/ with rendered versions ──────
# halonconfig copies the placeholder yaml into dist/; envsubst substitutes the
# real values so only the processed dist/ files (which are gitignored) ever
# contain secrets.
envsubst '${MSUI_DB_PASSWORD} ${MSUI_ADMIN_PASSWORD} ${ELASTIC_USERNAME} ${ELASTIC_PASSWORD}' \
  < src/config/msui.yaml > dist/msui.yaml

envsubst '${SMTPD_ELASTIC_BASIC_AUTH}' \
  < src/config/smtpd.yaml > dist/smtpd.yaml

envsubst '${WEB_ADMIN_PASSWORD} ${WEB_OIDC_CLIENT_SECRET} ${ELASTIC_USERNAME} ${ELASTIC_PASSWORD} ${WEB_PRIVATE_KEY_INDENTED}' \
  < src/config/web.yaml > dist/web.yaml

# ── 5. Deploy ────────────────────────────────────────────────────────────────
sudo cp dist/* /etc/halon/
sudo systemctl restart halon-smtpd
sudo systemctl restart halon-web
sudo systemctl restart halon-msui
sudo systemctl restart halon-dlpd
