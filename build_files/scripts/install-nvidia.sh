#!/usr/bin/env bash
set -ouex pipefail

# =============================================================================
# NVIDIA Open Drivers Installation
# Based on wayblue's nvidia-open-modules
# =============================================================================

# Install ublue-os NVIDIA support packages
dnf5 -y install /tmp/rpms/ublue-os/ublue-os-nvidia*.rpm

# Enable negativo17 NVIDIA repo with priority 90
sed -i '0,/enabled=0/{s/enabled=0/enabled=1\npriority=90/}' /etc/yum.repos.d/negativo17-fedora-nvidia.repo

# Install kernel modules and NVIDIA driver packages
dnf5 -y install \
    /tmp/rpms/kmods/kmod-nvidia*.rpm \
    libnvidia-fbc \
    libva-nvidia-driver \
    nvidia-driver \
    nvidia-driver-cuda \
    nvidia-modprobe \
    nvidia-persistenced \
    nvidia-settings

# Configure dracut for early NVIDIA loading
# Change omit_drivers to force_drivers and add i915/amdgpu support
sed -i 's@omit_drivers@force_drivers@g' /usr/lib/dracut/dracut.conf.d/99-nvidia.conf
sed -i 's@ nvidia @ i915 amdgpu nvidia @g' /usr/lib/dracut/dracut.conf.d/99-nvidia.conf

# Configure NVIDIA DRM modeset
mkdir -p /usr/lib/modprobe.d /etc/modprobe.d
cat > /usr/lib/modprobe.d/nvidia-modeset.conf << 'EOF'
# Nvidia modesetting support. Set to 0 or comment to disable kernel modesetting
# support. This must be disabled in case of SLI Mosaic.
options nvidia-drm modeset=1 fbdev=1
EOF
cp /usr/lib/modprobe.d/nvidia-modeset.conf /etc/modprobe.d/nvidia-modeset.conf

# Clean up NVIDIA repo (updates baked into image)
rm -f /etc/yum.repos.d/negativo17-fedora-nvidia.repo
