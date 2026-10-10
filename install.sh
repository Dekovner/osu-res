#!/usr/bin/env bash
set -e

BIN_DIR="${HOME}/.local/bin"
CONFIG_DIR="${HOME}/.local/share/osuconfig/configs"

echo "Installing osu-res to ${BIN_DIR}..."
mkdir -p "${BIN_DIR}"
cp osu-res "${BIN_DIR}/osu-res"
chmod +x "${BIN_DIR}/osu-res"

# Set up auto-hook if osu-winello is detected
if [ -d "${CONFIG_DIR}" ]; then
    echo "Configuring automatic launch hook for osu-winello..."
    cat << 'EOF' > "${CONFIG_DIR}/custom_resolutions.cfg"
# Auto-apply custom resolutions to Wine and XRandR on osu! launch
osu-res apply >/dev/null 2>&1
EOF
fi

# Run initial apply
"${BIN_DIR}/osu-res" apply >/dev/null 2>&1 || true

echo "Installation complete! Run 'osu-res' to manage your custom resolutions."
