#!/usr/bin/env bash
set -ouex pipefail

# Enable systemd services for Hyprland desktop

# Display manager
systemctl enable sddm.service
