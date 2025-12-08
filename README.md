# hyprland-bootc

Hyprland desktop images for Fedora bootc.

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

### NVIDIA variant adds

- NVIDIA open kernel modules (from ublue-os/akmods-nvidia-open)
- nvidia-driver, nvidia-settings, nvidia-persistenced
- libva-nvidia-driver, libnvidia-fbc

## Building locally

```bash
# Base Hyprland
podman build --target hyprland -t hyprland .

# NVIDIA variant
podman build --target hyprland-nvidia-open -t hyprland-nvidia-open .
```

## Contributing

Contributions welcome! Please open issues or PRs.

## Credits

Inspired by [wayblue's Hyprland images](https://github.com/wayblueorg/wayblue). This project uses native bootc Containerfiles instead of BlueBuild.
