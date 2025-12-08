# Hyprland Bootc Images
# Build targets: hyprland, hyprland-nvidia-open

default_image := "hyprland-bootc-nvidia-open"

# List available recipes
default:
    @just --list

# Build base hyprland image
build-hyprland:
    podman build --target hyprland -t hyprland-bootc .

# Build hyprland with NVIDIA open drivers
build-nvidia:
    podman build --target hyprland-nvidia-open -t hyprland-bootc-nvidia-open .

# Build both images
build-all: build-hyprland build-nvidia

# Build default image (nvidia-open)
build:
    podman build --target hyprland-nvidia-open -t {{ default_image }} .

# Build with no cache
build-clean:
    podman build --no-cache --target hyprland-nvidia-open -t {{ default_image }} .

# Run bootc lint on an image
lint image=default_image:
    podman run --rm localhost/{{ image }}:latest bootc container lint

# Lint both images
lint-all: (lint "hyprland-bootc") (lint "hyprland-bootc-nvidia-open")

# Remove built images
clean:
    -podman rmi hyprland-bootc:latest hyprland-bootc-nvidia-open:latest
