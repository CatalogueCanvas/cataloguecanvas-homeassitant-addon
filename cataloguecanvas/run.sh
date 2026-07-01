#!/bin/sh
# Home Assistant passes add-on options as JSON at /data/options.json. Translate
# them into the CC_* environment variables the upstream image expects, then hand
# off to the upstream entrypoint (which generates the session key under /data)
# and CMD. python is already present in the image, so no extra deps are needed.
set -e

OPTIONS_FILE="${OPTIONS_FILE:-/data/options.json}"

# Emit `export KEY=value` lines for each option, safely quoted. Missing file or
# keys fall back to empty, letting the app apply its own defaults.
eval "$(python - "$OPTIONS_FILE" <<'PY'
import json, shlex, sys

path = sys.argv[1]
try:
    with open(path) as fh:
        opts = json.load(fh)
except (FileNotFoundError, ValueError):
    opts = {}

mapping = {
    "admin_password": "CC_ADMIN_PASSWORD",
    "admin_username": "CC_ADMIN_USERNAME",
    "site_title": "CC_SITE_TITLE",
    "site_author": "CC_SITE_AUTHOR",
    "cookie_secure": "CC_COOKIE_SECURE",
    "llm_allowed_hosts": "CC_LLM_ALLOWED_HOSTS",
    "max_upload_bytes": "CC_MAX_UPLOAD_BYTES",
}

for opt_key, env_key in mapping.items():
    if opt_key not in opts:
        continue
    value = opts[opt_key]
    if isinstance(value, bool):
        value = "true" if value else "false"
    else:
        value = str(value)
    print(f"export {env_key}={shlex.quote(value)}")
PY
)"

if [ -z "${CC_ADMIN_PASSWORD:-}" ]; then
    echo "[cataloguecanvas] WARNING: admin_password is empty; the app fails closed" \
         "(no admin login) until you set it in the add-on configuration." >&2
fi

exec /usr/local/bin/docker-entrypoint.sh \
    uv run uvicorn cataloguecanvas.main:app --host 0.0.0.0 --port 8000
