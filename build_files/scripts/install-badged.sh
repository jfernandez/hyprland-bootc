#!/usr/bin/env bash
set -ouex pipefail

# Install badged (polkit authentication agent)
# https://github.com/jfernandez/badged
BADGED_VERSION="${BADGED_VERSION:-v0.1.0}"
BADGED_URL="https://github.com/jfernandez/badged/releases/download/${BADGED_VERSION}/badged-x86_64-unknown-linux-gnu"

curl --retry 5 -fsSL "$BADGED_URL" -o /usr/bin/badged
chmod +x /usr/bin/badged
