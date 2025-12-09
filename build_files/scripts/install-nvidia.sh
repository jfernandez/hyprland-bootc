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

# Configure dracut to include GPU drivers in initramfs
# - Upstream defaults to omit_drivers (excludes from initramfs, loads later)
# - We use force_drivers to ensure early loading during boot
# - Include i915/amdgpu for hybrid GPU laptop support (Intel/AMD + NVIDIA)
sed -i 's@omit_drivers@force_drivers@g' /usr/lib/dracut/dracut.conf.d/99-nvidia.conf
sed -i 's@ nvidia @ i915 amdgpu nvidia @g' /usr/lib/dracut/dracut.conf.d/99-nvidia.conf

# Configure NVIDIA kernel module options
# - modeset=1: Enable kernel mode setting (required for Wayland)
# - fbdev=1: Enable framebuffer device (improves suspend/resume and display handoff)
mkdir -p /usr/lib/modprobe.d /etc/modprobe.d
cat > /usr/lib/modprobe.d/nvidia-modeset.conf << 'EOF'
options nvidia-drm modeset=1 fbdev=1
EOF
cp /usr/lib/modprobe.d/nvidia-modeset.conf /etc/modprobe.d/nvidia-modeset.conf

# Regenerate initramfs with the new configuration
# Must run after all dracut/modprobe changes to bake drivers into the image
QUALIFIED_KERNEL="$(rpm -qa | grep -P 'kernel-(\d+\.\d+\.\d+)' | sed -E 's/kernel-//')"
/usr/bin/dracut --no-hostonly --kver "$QUALIFIED_KERNEL" --reproducible -v --add ostree -f "/lib/modules/$QUALIFIED_KERNEL/initramfs.img"
chmod 0600 "/lib/modules/$QUALIFIED_KERNEL/initramfs.img"

# Clean up NVIDIA repo (updates baked into image)
rm -f /etc/yum.repos.d/negativo17-fedora-nvidia.repo
