# hyprland-bootc

Hyprland desktop images built on [Fedora bootc](https://gitlab.com/fedora/bootc/base-images), the official base image for bootable containers.

## Images

| Image | Description |
|-------|-------------|
| `ghcr.io/jfernandez/hyprland-bootc` | Base Hyprland desktop |
| `ghcr.io/jfernandez/hyprland-bootc-nvidia-open` | Hyprland with NVIDIA open kernel modules |

## Usage

### Install on existing Fedora Atomic system

```bash
# Base Hyprland
sudo bootc switch ghcr.io/jfernandez/hyprland-bootc:latest

# With NVIDIA open drivers
sudo bootc switch ghcr.io/jfernandez/hyprland-bootc-nvidia-open:latest
```

### Use as base image

```dockerfile
FROM ghcr.io/jfernandez/hyprland-bootc-nvidia-open:latest

# Add your customizations
RUN dnf5 install -y your-packages
COPY your-configs /etc/
```

## What's included

- **Window Manager**: Hyprland, hyprpaper, hyprlock, hypridle
- **Display Manager**: SDDM with maldives theme
- **Terminal**: Kitty
- **Status Bar**: Waybar
- **Launcher**: Rofi, Wofi
- **File Manager**: Thunar with plugins and GVFS
- **Audio**: PipeWire, WirePlumber, pavucontrol
- **Screenshots**: grim, slurp
- **Clipboard**: wl-clipboard
- **Notifications**: dunst
- **Theming**: Papirus icons, FontAwesome fonts
- **App Store**: Flatpak with Flathub, Bazaar GUI

### NVIDIA variant adds

- NVIDIA open kernel modules (from ublue-os/akmods-nvidia-open)
- nvidia-driver, nvidia-settings, nvidia-persistenced
- libva-nvidia-driver, libnvidia-fbc

## Design choices

### Polkit agent: Badged

Uses [Badged](https://github.com/jfernandez/badged), a lightweight GTK4-based polkit authentication agent with built-in fingerprint support via pam_fprintd.

A custom `/etc/pam.d/polkit-1` configuration enables fingerprint authentication, so privilege escalation prompts (like 1Password unlock or mounting drives) can use your fingerprint reader.

### Networking: iwd + systemd-networkd

Eschews NetworkManager in favor of a lighter stack:

- **iwd** for WiFi management (faster connections, lower memory)
- **systemd-networkd** for ethernet (DHCP with metric 100)
- **systemd-resolved** for DNS resolution
- **impala** TUI for user-friendly WiFi management (`kitty impala`)

The `systemd-networkd-wait-online.service` is masked to prevent boot delays when no network is available.

### Hyprland configuration

The system-wide config at `/etc/xdg/hypr/hyprland.conf` provides sensible defaults:

- NVIDIA environment variables (ignored without NVIDIA drivers)
- Electron/Chromium forced to Wayland for sharp fractional scaling
- Waybar and Badged polkit agent autostarted
- Minimal keybindings: `Super+Return` (terminal), `Super+Space` (launcher), `Super+Q` (close)
- Media keys for brightness and volume control

Users override with `~/.config/hypr/hyprland.conf`.

### Polkit rules for disk mounting

The wheel group can mount filesystems without authentication, enabling Thunar to mount USB drives seamlessly.

### SDDM theming

The maldives theme is patched at build time to use white text for better visibility.

### tmpfiles.d declarations

Bootc images have an immutable `/var` at build time. The `hyprland-bootc.conf` tmpfiles config creates required directories (`/var/lib/iwd`, `/var/lib/flatpak`, etc.) at first boot.

## Building locally

```bash
# Using just (recommended)
just build          # Default: nvidia-open variant
just build-hyprland # Base variant
just build-all      # Both variants

# Using podman directly
podman build --target hyprland -t hyprland-bootc .
podman build --target hyprland-nvidia-open -t hyprland-bootc-nvidia-open .
```

## CI/CD

Images are built daily via GitHub Actions and pushed to `ghcr.io`. Each image is signed with cosign using keyless signing. Tags include `latest`, `YYYYMMDD`, and `latest.YYYYMMDD`.

## Contributing

Contributions welcome! Please open issues or PRs.

## Credits

Inspired by [wayblue](https://github.com/wayblueorg/wayblue) and [omarchy](https://omarchy.org). This project uses native bootc Containerfiles instead of BlueBuild.
