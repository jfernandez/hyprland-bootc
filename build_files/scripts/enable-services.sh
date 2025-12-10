#!/usr/bin/env bash
set -ouex pipefail

# Enable systemd services for Hyprland desktop

# Display manager
systemctl enable sddm.service

# Networking: iwd for wifi, systemd-networkd for ethernet
systemctl enable iwd.service
systemctl enable systemd-networkd.service
systemctl enable systemd-resolved.service

# DNS: use systemd-resolved stub resolver
ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

# Disable network-wait-online to prevent boot delays
systemctl disable systemd-networkd-wait-online.service
systemctl mask systemd-networkd-wait-online.service

# Create system users/groups from sysusers.d configs
# Required because systemd doesn't run during container build
systemd-sysusers
