#!/usr/bin/env bash
set -ouex pipefail

# =============================================================================
# Desktop Environment Installation
# Hyprland, SDDM, Wayland tools, and common desktop packages
# Based on wayblue's hyprland, sddm, and common modules
# =============================================================================

# Install dnf5 plugins (required for copr command)
dnf5 -y install dnf5-plugins

# Enable Hyprland COPR
dnf5 -y copr enable solopasha/hyprland

# -----------------------------------------------------------------------------
# SDDM Display Manager
# -----------------------------------------------------------------------------
dnf5 -y --setopt=install_weak_deps=False install \
    sddm \
    sddm-themes \
    qt5-qtgraphicaleffects \
    qt5-qtquickcontrols2 \
    qt5-qtsvg

# -----------------------------------------------------------------------------
# Hyprland Window Manager
# -----------------------------------------------------------------------------
dnf5 -y --setopt=install_weak_deps=False install \
    hyprland \
    hyprpaper \
    hyprlock \
    hypridle \
    hyprland-qtutils \
    kitty \
    waybar \
    xdg-desktop-portal-hyprland

# -----------------------------------------------------------------------------
# Launchers
# -----------------------------------------------------------------------------
dnf5 -y --setopt=install_weak_deps=False install \
    rofi-wayland \
    wofi

# -----------------------------------------------------------------------------
# Environment & System Tools
# -----------------------------------------------------------------------------
dnf5 -y --setopt=install_weak_deps=False install \
    glibc-langpack-en \
    tuned-ppd \
    xorg-x11-server-Xwayland \
    mediainfo \
    polkit \
    xfce-polkit \
    fprintd-pam \
    xdg-user-dirs \
    dbus-tools \
    dbus-daemon \
    wl-clipboard \
    pavucontrol \
    playerctl \
    qt5-qtwayland \
    qt6-qtwayland \
    vulkan-tools \
    google-noto-emoji-fonts \
    gnome-disk-utility \
    ddcutil \
    alsa-firmware \
    p7zip

# -----------------------------------------------------------------------------
# PipeWire Audio Stack
# -----------------------------------------------------------------------------
dnf5 -y --setopt=install_weak_deps=False install \
    wireplumber \
    pipewire \
    pamixer

# -----------------------------------------------------------------------------
# Networking (iwd + systemd-networkd)
# -----------------------------------------------------------------------------
dnf5 -y --setopt=install_weak_deps=False install \
    iwd \
    iw \
    wireless-regdb \
    systemd-networkd \
    systemd-resolved \
    bluez \
    bluez-tools \
    blueman \
    firewall-config

# Install impala (wifi TUI) from GitHub releases
curl -fsSL https://github.com/pythops/impala/releases/download/v0.6.0/impala-x86_64-unknown-linux-gnu \
    -o /usr/bin/impala && chmod +x /usr/bin/impala

# -----------------------------------------------------------------------------
# Firmware (required for wifi and other hardware)
# -----------------------------------------------------------------------------
dnf5 -y --setopt=install_weak_deps=False install \
    linux-firmware

# -----------------------------------------------------------------------------
# Thunar File Manager
# -----------------------------------------------------------------------------
dnf5 -y --setopt=install_weak_deps=False install \
    thunar \
    thunar-archive-plugin \
    thunar-volman \
    xarchiver \
    imv \
    gvfs-mtp \
    gvfs-gphoto2 \
    gvfs-smb \
    gvfs-nfs \
    gvfs-fuse \
    gvfs-archive

# -----------------------------------------------------------------------------
# Screenshot Tools
# -----------------------------------------------------------------------------
dnf5 -y --setopt=install_weak_deps=False install \
    slurp \
    grim

# -----------------------------------------------------------------------------
# Display Management
# -----------------------------------------------------------------------------
dnf5 -y --setopt=install_weak_deps=False install \
    wlr-randr \
    wlsunset \
    brightnessctl \
    kanshi

# -----------------------------------------------------------------------------
# Notifications
# -----------------------------------------------------------------------------
dnf5 -y --setopt=install_weak_deps=False install \
    dunst

# -----------------------------------------------------------------------------
# Theming & Icons
# -----------------------------------------------------------------------------
dnf5 -y --setopt=install_weak_deps=False install \
    fontawesome-fonts-all \
    google-noto-sans-mono-fonts \
    gnome-themes-extra \
    gnome-icon-theme \
    paper-icon-theme \
    breeze-icon-theme \
    papirus-icon-theme

# -----------------------------------------------------------------------------
# Post-install: SDDM theming (maldives theme with white text)
# -----------------------------------------------------------------------------
if [[ -f /usr/share/sddm/themes/maldives/Main.qml ]]; then
    sed -i 's/color: "black"/color: "white"/' /usr/share/sddm/themes/maldives/Main.qml
    sed -i 's/id: lblPassword/id: lblPassword\ncolor: "white"/' /usr/share/sddm/themes/maldives/Main.qml
    sed -i 's/id: lblName/id: lblName\ncolor: "white"/' /usr/share/sddm/themes/maldives/Main.qml
    sed -i 's/id: lblSession/id: lblSession\ncolor: "white"/' /usr/share/sddm/themes/maldives/Main.qml
    sed -i 's/id: lblLayout/id: lblLayout\ncolor: "white"/' /usr/share/sddm/themes/maldives/Main.qml
    sed -i 's/id: errorMessage/id: errorMessage\ncolor: "white"/' /usr/share/sddm/themes/maldives/Main.qml
fi

# Disable COPR
dnf5 -y copr disable solopasha/hyprland
