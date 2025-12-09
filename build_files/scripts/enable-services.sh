#!/usr/bin/env bash
set -ouex pipefail

# Enable systemd services for Hyprland desktop

# Display manager
systemctl enable sddm.service

# Create system users/groups from sysusers.d configs
# Required because systemd doesn't run during container build
systemd-sysusers
