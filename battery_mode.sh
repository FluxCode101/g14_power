#!/bin/bash
# g14-battery-mode.sh
# Apply ASUS G14 battery-optimized settings

# =========================
#  Display Settings
# =========================

# Detect internal display (Wayland/KDE)
DISPLAY_OUT=$(kscreen-doctor -o | grep connected | awk '{print $2}' | head -n1)

# Try switching to 60Hz if available
MODE_ID=$(kscreen-doctor -o | grep -A10 "$DISPLAY_OUT" | grep 60 | awk -F: '{print $1}' | tr -d ' ')
if [[ -n "$MODE_ID" ]]; then
    kscreen-doctor output.$DISPLAY_OUT.mode.$MODE_ID
fi

# Brightness to 50%
brightnessctl set 50%

# =========================
#  GPU Settings
# =========================

# Prefer iGPU
asusctl gfx -m integrated

# Runtime suspend dGPU if still present
echo "auto" | sudo tee /sys/bus/pci/devices/0000:01:00.0/power/control >/dev/null

# =========================
#  Keyboard + LEDs
# =========================

# Turn OFF keyboard backlight
asusctl -k off

# =========================
#  CPU + Platform Power
# =========================

# CPU governor to powersave
for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    echo powersave | sudo tee $cpu
done

# Enable maximum PCIe ASPM savings
echo powersupersave | sudo tee /sys/module/pcie_aspm/parameters/policy >/dev/null

# =========================
#  Wi-Fi + NVMe
# =========================

# Detect Wi-Fi interface
WLAN=$(iw dev | awk '$1=="Interface"{print $2}' | head -n1)
if [[ -n "$WLAN" ]]; then
    iw dev "$WLAN" set power_save on
fi

# NVMe powersave
for dev in /sys/class/nvme/nvme*/device/power/control; do
    echo auto | sudo tee $dev >/dev/null
done

# =========================
#  ASUS Profile
# =========================

# Quiet fan/cpu profile
asusctl profile -P quiet

echo "✅ Battery mode optimizations applied."
