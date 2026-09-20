#!/usr/bin/env bash
set -euo pipefail

SETTINGS_FILE=".vscode/settings.json"   # adjust path as needed

# Detect the JDK actually present in this running container.
jdkhome=$(dirname "$(dirname "$(readlink -f "$(which java)")")")

mkdir -p "$(dirname "$SETTINGS_FILE")"

if [ ! -f "$SETTINGS_FILE" ]; then
  # No settings.json at all yet — create it fresh
  cat > "$SETTINGS_FILE" << EOF
{
    "jdk.jdkhome": "$jdkhome"
}
EOF
elif ! grep -q '"jdk.jdkhome"' "$SETTINGS_FILE"; then
  if grep -qE '^\s*\{\s*\}\s*$' "$SETTINGS_FILE"; then
    # File exists but is just an empty object
    sed -i "s#{[[:space:]]*}#{\\n    \"jdk.jdkhome\": \"$jdkhome\"\\n}#" "$SETTINGS_FILE"
  else
    # File has existing keys — insert before the final closing brace
    sed -i "\$s#^}\$#,\\n    \"jdk.jdkhome\": \"$jdkhome\"\\n}#" "$SETTINGS_FILE"
  fi
fi