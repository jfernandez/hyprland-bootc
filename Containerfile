# =============================================================================
# Hyprland Bootc Images
# =============================================================================
# Community-maintained Hyprland desktop images for Fedora bootc.
#
# Targets:
#   - hyprland:            Base Hyprland desktop
#   - hyprland-nvidia-open: Hyprland with NVIDIA open kernel modules
#
# Build:
#   podman build --target hyprland -t hyprland .
#   podman build --target hyprland-nvidia-open -t hyprland-nvidia-open .
# =============================================================================

# -----------------------------------------------------------------------------
# Build contexts
# -----------------------------------------------------------------------------
FROM scratch AS build-ctx
COPY build_files /build_files

FROM scratch AS system-ctx
COPY files/system /system

# NVIDIA open kernel modules from ublue-os
FROM ghcr.io/ublue-os/akmods-nvidia-open:main-43 AS akmods

# =============================================================================
# Target: hyprland
# Base Hyprland desktop without NVIDIA drivers
# =============================================================================
FROM quay.io/fedora/fedora-bootc:43 AS hyprland

# Desktop environment
RUN --mount=type=cache,dst=/var/cache/libdnf5,sharing=locked \
    --mount=type=cache,dst=/var/cache/dnf,sharing=locked \
    --mount=type=bind,from=build-ctx,source=/,target=/ctx \
    /ctx/build_files/scripts/install-desktop.sh

# Badged polkit agent
RUN --mount=type=bind,from=build-ctx,source=/,target=/ctx \
    /ctx/build_files/scripts/install-badged.sh

# System configuration files
COPY --from=system-ctx /system /

# Enable systemd services
RUN --mount=type=bind,from=build-ctx,source=/,target=/ctx \
    /ctx/build_files/scripts/enable-services.sh

# Cleanup
RUN rm -rf /var/log/* /var/cache/* && \
    rm -rf /var/lib/dnf /var/lib/rpm-state

# Labels
LABEL org.opencontainers.image.title="hyprland-bootc"
LABEL org.opencontainers.image.description="Hyprland desktop on Fedora bootc"
LABEL containers.bootc="1"
LABEL ostree.bootable="1"

# Validate
RUN bootc container lint

# =============================================================================
# Target: hyprland-nvidia-open
# Hyprland desktop with NVIDIA open kernel modules
# =============================================================================
FROM quay.io/fedora/fedora-bootc:43 AS hyprland-nvidia-open

# NVIDIA open drivers (installed first for layer caching)
COPY --from=akmods /rpms /tmp/rpms
RUN --mount=type=cache,dst=/var/cache/libdnf5,sharing=locked \
    --mount=type=cache,dst=/var/cache/dnf,sharing=locked \
    --mount=type=bind,from=build-ctx,source=/,target=/ctx \
    /ctx/build_files/scripts/install-nvidia.sh

# Desktop environment (same as base)
RUN --mount=type=cache,dst=/var/cache/libdnf5,sharing=locked \
    --mount=type=cache,dst=/var/cache/dnf,sharing=locked \
    --mount=type=bind,from=build-ctx,source=/,target=/ctx \
    /ctx/build_files/scripts/install-desktop.sh

# Badged polkit agent
RUN --mount=type=bind,from=build-ctx,source=/,target=/ctx \
    /ctx/build_files/scripts/install-badged.sh

# System configuration files
COPY --from=system-ctx /system /

# Enable systemd services
RUN --mount=type=bind,from=build-ctx,source=/,target=/ctx \
    /ctx/build_files/scripts/enable-services.sh

# Cleanup
RUN rm -rf /tmp/rpms /var/log/* /var/cache/* && \
    rm -rf /var/lib/dnf /var/lib/rpm-state

# Labels
LABEL org.opencontainers.image.title="hyprland-bootc-nvidia-open"
LABEL org.opencontainers.image.description="Hyprland desktop on Fedora bootc with NVIDIA open drivers"
LABEL containers.bootc="1"
LABEL ostree.bootable="1"

# Validate
RUN bootc container lint
