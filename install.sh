#!/bin/bash

# Function to create a directory if it does not exist:
create_dir_if_not_exists() {
    if [ ! -d "$1" ]; then
        mkdir -p "$1"
    fi
}

create_dir_if_not_exists "$HOME/.themes"
create_dir_if_not_exists "/usr/share/themes"
create_dir_if_not_exists "$HOME/.icons"
create_dir_if_not_exists "/usr/share/icons"
create_dir_if_not_exists "$HOME/.local/share/xfce4-panel-profiles"
create_dir_if_not_exists "$HOME/.config/menus/menu-backup"

cp -r Theme/MENT2K "$HOME/.themes/"
cp -r Theme/MENT2K "/usr/share/themes/"
cp -r Icons/Idk2k "$HOME/.icons/"
cp -r Icons/Idk2k "/usr/share/icons/"

sudo apt update
sudo apt install -y marco mate-tweak gtk2-engines-pixbuf xfce4-panel-profiles picom

cp Misc/Panel-profiles/Win-2000.tar.bz2 "$HOME/.local/share/xfce4-panel-profiles/"

cp -r "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml" "$HOME/.config/menus/menu-backup/xfce4-panel.xml.bak"

xfce4-panel-profile load "$HOME/.local/share/xfce4-panel-profiles/Win-2000.tar.bz2"

gsettings set org.gnome.desktop.interface gtk-theme 'MENT2K'
gsettings set org.gnome.desktop.interface icon-theme 'Idk2k'
gsettings set org.mate.interface gtk-theme 'MENT2K'
gsettings set org.mate.interface icon-theme 'Idk2k'

xfconf-query --channel xsettings --property /Gtk/ThemeName --set 'MENT2K'
xfconf-query --channel xsettings --property /Gtk/IconThemeName --set 'Idk2k'

create_dir_if_not_exists "$HOME/.config/menus/menu-backup"
mv "$HOME/.config/menus/applications-merged" "$HOME/.config/menus/menu-backup/"
mv "$HOME/.config/menus/xfce-applications.menu" "$HOME/.config/menus/menu-backup/"

cp -r Misc/menus/* "$HOME/.config/menus/"

cp -r Misc/desktop-shortcuts/ "$HOME/Desktop/"
# Make marco the default window manager
update-alternatives --set x-session-manager /usr/bin/marco

# Move Misc/Redmond97 to ~/.themes
cp -r Misc/Redmond97 "$HOME/.themes/"

# Apply Redmond97 as the marco window manager theme
gsettings set org.mate.Marco.general theme 'Redmond97'

# Set picom as compositor without window shadows
picom --config ~/.config/picom.conf --backend glx --vsync opengl-swc --no-fading-shadow --no-dock-shadow --no-shadow

# Change the xfdesktop wallpaper to just the color "#3D6FA2"
xfconf-query --channel xfce4-desktop --property /backdrop/screen0/monitor0/workspace0/last-image --set ""
xfconf-query --channel xfce4-desktop --property /backdrop/screen0/monitor0/workspace0/color --set "#3D6FA2"

echo "Installation and configuration complete."
