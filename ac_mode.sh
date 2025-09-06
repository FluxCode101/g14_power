#!/bin/bash
# g14-ac-mode.sh
# Apply ASUS G14 AC (performance) settings

# =========================
#  Display Settings
# =========================

# Detect internal display (Wayland/KDE)
DISPLAY_OUT=$(kscreen-doctor -o | grep connected | awk '{print $2}' | head -n1)

# Try switching to 165Hz if available
MODE_ID=$(kscreen-doctor -o | grep -A10 "$DISPLAY_OUT" | grep 165 | awk -F: '{print $1}' | tr -d ' ')
if [[ -n "$MODE_ID" ]]; then
    kscreen-doctor output.$DISPLAY_OUT.mode.$MODE_ID
fi

# Brightness to 100%
brightnessctl set 100%

# =========================
#  GPU Settings
# =========================

# Ensure Hybrid mode with dGPU available
asusctl gfx -m hybrid

# Keep NVIDIA GPU awake
echo "on" | sudo tee /sys/bus/pci/devices/0000:01:00.0/power/control >/dev/null

# =========================
#  Keyboard + LEDs
# =========================

# Turn OFF keyboard backlight (as requested)
asusctl -k off

# =========================
#  CPU + Platform Power
# =========================

# CPU governor to performance
for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    echo performance | sudo tee $cpu
done

# PCIe ASPM to "default" (kernel decides)
echo default | sudo tee /sys/module/pcie_aspm/parameters/policy >/dev/null

# =========================
#  Wi-Fi + NVMe
# =========================

# Detect Wi-Fi interface
WLAN=$(iw dev | awk '$1=="Interface"{print $2}' | head -n1)
if [[ -n "$WLAN" ]]; then
    iw dev "$WLAN" set power_save off
fi

# NVMe performance mode
for dev in /sys/class/nvme/nvme*/device/power/control; do
    echo on | sudo tee $dev >/dev/null
done

# =========================
#  ASUS Profile
# =========================

# Performance fan/cpu profile
asusctl profile -P performance

echo "✅ AC mode performance settings applied."
