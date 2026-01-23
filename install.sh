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
sudo cp -r Theme/MENT2K "/usr/share/themes/"
cp -r Icons/Idk2k "$HOME/.icons/"
sudo cp -r Icons/Idk2k "/usr/share/icons/"
sleep 0.5
sudo cp -v "Lightdm/lightdm-gtk-greeter.css" "/usr/share/themes/MENT2K/gtk-3.0/apps/lightdm-gtk-greeter.css"

sudo apt update
sudo apt install -y lxappearance marco mate-control-center mate-tweak gtk2-engines-pixbuf xfce4-panel-profiles picom

cp -r Misc/Panel-profiles/MENT2K.tar.bz2 "$HOME/.local/share/xfce4-panel-profiles/"

cp -r "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml" "$HOME/.config/menus/menu-backup/xfce4-panel.xml.bak"

xfce4-panel-profiles load "$HOME/.local/share/xfce4-panel-profiles/MENT2K.tar.bz2"
s
gsettings set org.gnome.desktop.interface gtk-theme 'MENT2K'
gsettings set org.gnome.desktop.interface icon-theme 'Idk2k'
gsettings set org.mate.interface gtk-theme 'MENT2K'
gsettings set org.mate.interface icon-theme 'Idk2k'

xfconf-query --channel xsettings --property /Gtk/ThemeName --set 'MENT2K'
xfconf-query --channel xsettings --property /Gtk/IconThemeName --set 'Idk2k'

# Change cursor theme:

echo "Changing cursor theme..."

mkdir -p ~/.icons/default

cp "Misc/index.theme" ~/.icons/default/

sudo cp -r "Cursors/Chicago95 Standard Cursors" "/usr/share/icons"

sleep 0.2

ln -s "usr/share/icons/Chicago95 Standard Cursors/cursors" ~/.icons/default/cursors



create_dir_if_not_exists "$HOME/.config/menus/menu-backup"
mv "$HOME/.config/menus/applications-merged" "$HOME/.config/menus/menu-backup/"
mv "$HOME/.config/menus/xfce-applications.menu" "$HOME/.config/menus/menu-backup/"

sudo cp -r Misc/menus/* "$HOME/.config/menus/"

cp -r Misc/desktop-shortcuts/ "$HOME/Desktop"

# Make marco the default window manager
update-alternatives --set x-session-manager /usr/bin/marco

echo "Process: Marco theme"
git clone https://github.com/matthewmx86/Redmond97.git

if [ $? -ne 0 ]; then
    echo "Failed to clone the Redmond97 repository."
fi

echo "Moving marco theme to ~/.themes..."
sudo cp -r "Redmond97/Theme/no-csd/Redmond97 Millennium" ~/.themes

if [ $? -ne 0 ]; then
    echo "Failed to move the theme."
fi

echo "Deleting cloned Redmond97 directory..."
rm -rf Redmond97

if [ $? -ne 0 ]; then
    echo "Failed to delete the cloned Redmond97 directory."
fi

# Apply Redmond97 as the marco window manager theme

cp -r Misc/picom.conf ~/.config/

cp -r Misc/.startup ~/

mkdir -p ~/.config/autostart
cat > ~/.config/autostart/startup-marco.desktop <<'EOF'
[Desktop Entry]
Type=Application
Name=startup-marco
Exec=~/.startup/.startup-marco.sh
X-GNOME-Autostart-enabled=true
NoDisplay=false
EOF

chmod +x "$HOME/.startup/.startup-marco.sh"

gsettings set org.mate.Marco.general theme 'Redmond97 Millennium'
sleep 0.2
gsettings set org.mate.interface font-name 'Tahoma 8'
gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Tahoma Bold 8'
gsettings set org.mate.Marco.general titlebar-font 'Tahoma Bold 8'


# Change the xfdesktop wallpaper to just the color "#3D6FA2"
xfconf-query --channel xfce4-desktop --property /backdrop/screen0/monitoreDP-1/workspace0/rgba -s "[0.239216, 0.435294, 0.635294, 1.000000]"
xfconf-query --channel xfce4-desktop --property /backdrop/screen0/monitoreDP-1/workspace0/rgba -s [ 0.239216, 0.435294, 0.635294, 1.000000 ]
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorHDMI-1/workspace0/rgba --create -t double -s 0.239216 -s 0.435294 -s 0.635294 -s 1.0
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitoreDP-1/workspace0/rgba --create -t double -s 0.239216 -s 0.435294 -s 0.635294 -s 1.0
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorHDMI-1/workspace0/image-style -s 0
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitoreDP-1/workspace0/image-style -s 0
xfconf-query --channel xfce4-desktop --property /desktop-icons/icon-size --set 32
echo '(gtk_accel_path "<Actions>/ThunarWindow/view-location-selector-entry" "true")' >> ~/.config/Thunar/accels
xfconf-query --channel xsettings --property /Gtk/FontName --set "Tahoma 8"

FONT_ZIP_FILE="Tahoma-4styles-Font.zip"
EXTRACTED_FOLDER="Tahoma-4styles-Font"
PROJECT_FOLDER="$(pwd)"
FONT_FILES="TAHOMA_0.TTF" "TAHOMAB0.TTF" "TAHOMABD.TTF" "Tahoma Regular font.ttf"
SYSTEM_FONT_DIR="/usr/local/share/fonts/tahoma"

download_and_extract_font() {
  echo "Downloading $FONT_ZIP_FILE..."
  wget "https://www.dafontfree.co/wp-content/uploads/download-manager-files/Tahoma-4styles-Font.zip"
  sleep 2
  unzip -o "$FONT_ZIP_FILE" -d "$PROJECT_FOLDER/$EXTRACTED_FOLDER"
  sleep 2
}

install_fonts() {
    echo "Installing font files system-wide..."
    sudo cp -r "$EXTRACTED_FOLDER/$FONT_FILES" /usr/share/fonts/truetype/

    sudo fc-cache -fv
}


# Function to set Tahoma as the default font with specified settings
set_default_font() {
    echo "Setting Tahoma as the default font."

    # Set default font for Xfce
    xfconf-query --channel xsettings --property /Gtk/FontName --set "Tahoma 8"
    xfconf-query -c xsettings -p /Xft/Antialias -s 0
    xfconf-query -c xsettings -p /Xft/Hinting -s 1
    xfconf-query -c xsettings -p /Xft/HintStyle -s hintfull
    xfconf-query -c xsettings -p /Xft/RGBA -s vgbr

}

# Main script execution
printf 'Do you want to download and install the Tahoma font from https://www.dafontfree.co/download/tahoma/? (y/n): '
read -r confirm
case "$confirm" in
  y|Y)
    download_and_extract_font
    install_fonts
    set_default_font
    echo "Installed font."
    ;;
  *)
    echo "Aborted."
    ;;
esac

sudo mv -- /etc/lightdm/lightdm-gtk-greeter.conf /etc/lightdm/lightdm-gtk-greeter.conf.bak
sudo cp -r Lightdm/lightdm-gtk-greeter.conf /etc/lightdm/

# Whisker menu icon replacement:

if [[ ! -r "$HOME/MENT2K/Misc/windowsstart.png" ]]; then
  echo "icon missing"
fi

if xfconf-query -c xfce4-panel -p /plugins/plugin-5/button-image >/dev/null 2>&1; then
  xfconf-query -c xfce4-panel -p /plugins/plugin-5/button-image -s "$HOME/MENT2K/Misc/windowsstart.png"
else
  xfconf-query -c xfce4-panel -p /plugins/plugin-5/button-image --create -t string -s "$HOME/MENT2K/Misc/windowsstart.png"
fi

xfce4-panel -r

# Set picom as compositor without window shadows

marco --replace --no-composite &

sleep 0.8

pkill picom

picom --config ~/.config/picom.conf &

echo "Installation and configuration complete."
