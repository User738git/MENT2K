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

sudo apt update
sudo apt install -y marco mate-control-center mate-tweak gtk2-engines-pixbuf xfce4-panel-profiles picom

cp Misc/Panel-profiles/MENT2K.tar.bz2 "$HOME/.local/share/xfce4-panel-profiles/"

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

# Main script execution
change_whisker_menu_icon

echo "Cloning Redmond97 repository..."
git clone https://github.com/matthewmx86/Redmond97.git

if [ $? -ne 0 ]; then
    echo "Failed to clone the Redmond97 repository."
    exit 1
fi

echo "Moving theme to ~/.themes..."
mkdir -p ~/.themes
mv "Redmond97/Theme/no-csd/Redmond97 Millennium" ~/.themes

if [ $? -ne 0 ]; then
    echo "Failed to move the theme."
    exit 1
fi

echo "Deleting cloned Redmond97 directory..."
rm -rf Redmond97

if [ $? -ne 0 ]; then
    echo "Failed to delete the cloned Redmond97 directory."
    exit 1
fi

cp -r Misc/Redmond97 "$HOME/.themes/"

# Apply Redmond97 as the marco window manager theme
gsettings set org.mate.Marco.general theme 'Redmond97 Millennium'

# Set picom as compositor without window shadows
picom --config ~/.config/picom.conf --backend glx --vsync opengl-swc --no-fading-shadow --no-dock-shadow --no-shadow

# Change the xfdesktop wallpaper to just the color "#3D6FA2"
xfconf-query --channel xfce4-desktop --property /backdrop/screen0/monitor0/workspace0/last-image --set ""
xfconf-query --channel xfce4-desktop --property /backdrop/screen0/monitor0/workspace0/color --set "#3D6FA2"
xfconf-query --channel xfce4-desktop --property /desktop-icons/icon-size --set 32
echo '(gtk_accel_path "<Actions>/ThunarWindow/view-location-selector-entry" "true")' >> ~/.config/Thunar/accels
xfconf-query --channel xsettings --property /Gtk/FontName --set "Tahoma 8"

xfce4-panel -r

marco --replace

#!/bin/bash

# Define variables
FONT_ZIP_URL="https://www.dafontfree.co/wp-content/uploads/download-manager-files/Tahoma-4styles-Font.zip"
FONT_ZIP_FILE="Tahoma-4styles-Font.zip"
EXTRACTED_FOLDER="Tahoma-4styles-Font"
PROJECT_FOLDER="$(pwd)"
FONT_FILES=("TAHOMA_0.TTF" "TAHOMAB0.TTF" "TAHOMABD.TTF" "Tahoma Regular font.ttf")
LIGHTDM_CONF="/etc/lightdm/lightdm-gtk-greeter.conf"
LIGHTDM_CONF_BACKUP="${LIGHTDM_CONF}.bak"
THEME="MENT2K"
ICON_THEME="Idk2k"
BACKGROUND_COLOR="#3D6FA2"

# Function to download and extract the font zip file
download_and_extract_font() {
    echo "Downloading $FONT_ZIP_FILE..."
    wget -O "$FONT_ZIP_FILE" "$FONT_ZIP_URL"

    if [ $? -ne 0 ]; then
        echo "Failed to download $FONT_ZIP_FILE"
        exit 1
    fi

    echo "Extracting $FONT_ZIP_FILE..."
    unzip -o "$FONT_ZIP_FILE" -d "$PROJECT_FOLDER"

    if [ $? -ne 0 ]; then
        echo "Failed to extract $FONT_ZIP_FILE"
        exit 1
    fi
}

# Function to install font files system-wide
install_fonts() {
    echo "Installing font files system-wide..."
    for font in "${FONT_FILES[@]}"; do
        sudo cp "$PROJECT_FOLDER/$EXTRACTED_FOLDER/$font" /usr/share/fonts/truetype/
    done

    sudo fc-cache -fv
}

# Function to set Tahoma as the default font with specified settings
set_default_font() {
    echo "Setting Tahoma as the default font with 8pt size, full hinting, Vertical BGR as subpixel order, and no anti-aliasing..."

    # Set default font for Xfce
    xfconf-query --channel xsettings --property /Gtk/FontName --set "Tahoma 8"
    xfconf-query --channel xsettings --property /Gtk/HintStyle --set "hintfull"
    xfconf-query --channel xsettings --property /Gtk/Hinting --set "true"
    xfconf-query --channel xsettings --property /Gtk/SubpixelOrder --set "vbgr"
    xfconf-query --channel xsettings --property /Gtk/Antialias --set "false"

    # Set default font for LightDM greeter
    sudo sed -i 's/^#font-name=.*/font-name=Tahoma 8/' "$LIGHTDM_CONF"
    sudo sed -i 's/^#hinting=.*/hinting=true/' "$LIGHTDM_CONF"
    sudo sed -i 's/^#antialias=.*/antialias=false/' "$LIGHTDM_CONF"
}

# Function to apply the theme and icon theme to LightDM greeter
apply_lightdm_theme() {
    echo "Applying theme $THEME and icon theme $ICON_THEME to LightDM greeter..."

    # Backup the original LightDM configuration
    sudo cp "$LIGHTDM_CONF" "$LIGHTDM_CONF_BACKUP"

    # Apply the theme and icon theme
    sudo sed -i 's/^#gtk-theme-name=.*/gtk-theme-name='$THEME'/' "$LIGHTDM_CONF"
    sudo sed -i 's/^#icon-theme-name=.*/icon-theme-name='$ICON_THEME'/' "$LIGHTDM_CONF"

    # Set background color
    sudo sed -i 's/^#background=.*/background='$BACKGROUND_COLOR'/' "$LIGHTDM_CONF"
    sudo sed -i 's/^#background-image=.*/background-image=/' "$LIGHTDM_CONF"

    # Turn off user image
    sudo sed -i 's/^#show-user-image=.*/show-user-image=false/' "$LIGHTDM_CONF"
}

# Main script execution

# Main script execution
read -p "Do you want to download and install the Tahoma font from https://www.dafontfree.co/download/tahoma/? (y/n): " confirm
if [ "$confirm" == "y" ] || [ "$confirm" == "Y" ]; then
    download_and_extract_font
    install_fonts
    set_default_font
fi

apply_lightdm_theme

# Function to change the Whisker Menu panel icon
change_whisker_menu_icon() {
    echo "Changing Whisker Menu panel icon to Misc/windowsstart.png..."

    # Find the Whisker Menu plugin configuration file
    WHISKER_MENU_CONF=$(find ~/.config/xfce4/panel -name "whiskermenu-*.rc")

    if [ -z "$WHISKER_MENU_CONF" ]; then
        echo "Whisker Menu configuration file not found."
        exit 1
    fi

    # Backup the original configuration file
    cp "$WHISKER_MENU_CONF" "${WHISKER_MENU_CONF}.bak"

    # Change the icon property
    sed -i "s|icon=.*|icon=Misc/windowsstart.png|" "$WHISKER_MENU_CONF"

    echo "Whisker Menu panel icon changed successfully."
}

# Function to clone the Redmond97 repository and move the theme
clone_and_move_theme() {
    echo "Cloning Redmond97 repository..."
    git clone https://github.com/matthewmx86/Redmond97.git

    if [ $? -ne 0 ]; then
        echo "Failed to clone the Redmond97 repository."
        exit 1
    fi

    echo "Moving theme to ~/.themes..."
    mkdir -p ~/.themes
    mv "Redmond97/Theme/no-csd/Redmond97\ Millennium" ~/.themes

    if [ $? -ne 0 ]; then
        echo "Failed to move the theme."
        exit 1
    fi

    echo "Deleting cloned Redmond97 directory..."
    rm -rf Redmond97

    if [ $? -ne 0 ]; then
        echo "Failed to delete the cloned Redmond97 directory."
        exit 1
    fi

    echo "Theme moved and cloned directory deleted successfully."
}

# Main script execution
change_whisker_menu_icon
clone_and_move_theme

echo "Installation and configuration complete."
