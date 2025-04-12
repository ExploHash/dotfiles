# Update system first
sudo pacman -Syu

# Install yay
sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si

# Install packages for gui with hyperland
yay -S --noconfirm --needed \
    ly \
    hyprland \
    kitty \
    nautilus \
    wofi \
    firefox \
    gtk3 \
    waybar \
    pipewire \
    wireplumber \
    xdg-desktop-portal-hyprland \
    otf-font-awesome \
    lm_sensors \
    flameshot \
    hyprlock \
    grim \
    ttf-font-awesome \
    xcb-util



# Setup ly
sudo systemctl enable ly.service

# For audio
yay -S --noconfirm --needed \
    pulseaudio \
    pulseaudio-alsa \
    alsa-utils

# Applications
yay -S --noconfirm --needed \
    zed \
    tutanota-desktop-bin \
    discord \
    spotify \
    lens \
    kubecm
