<p align="center">
<img src="Screenshots/logo-crop.png" alt="Logo"/>
</p>

-----
## Remaining Steps:

<a name="index"/>

# Index

<!--ts-->
* [Remaining steps](#install_theme)
* [Optional Steps](#optional)
<!--te-->

## Remaining manual steps:

#### Desktop options:

Right click on your desktop background (xfdesktop) and click "Desktop settings"

Set style to "None".

Click on the color box and click on "+" under "Custom".

Paste in this color tag: #3D6FA2 and click "select".

Go into the "Desktop Icons" tab and change the icon size to 32.

Set the "Show icon tooltips: Size:" to 4.

You can optionally set the label background colour to "#3D6FA2".

----------

#### Thunar configuration:

    echo '(gtk_accel_path "<Actions>/ThunarWindow/view-location-selector-entry" "true")' >> ~/.config/Thunar/accels

Configure the Thunar toolbar to match this screenshot:

<img src="Screenshots/Thunarconf.png" alt="Thunar">


<a name="optional"/>

## Optional:

### Windows CMD font and CMD feel:

Download and extract:

    wget "https://www.yohng.com/files/TerminalVector.zip"
    unzip -o "TerminalVector.zip" -d ./TerminalVector
    
    sudo cp ./TerminalVector/TerminalVector.ttf /usr/share/fonts/truetype/
    sudo fc-cache -fv

Go into "Terminal Preferences" and into the "Appearance" tab.

Pick a font and pick the font "Terminal Vector Normal" and set the value of "Size" to 9.

Go to the "General" tab and set Dynamically-set title to "Isn't displayed" and "Initial title" to:

     Administrator: C:

Then set cursor shape to "Underline" and check "Cursor Blinks".

Add this line of code to the end of your .bashrc file (located in ~/):

	function msdos_pwd
	{
	    local dir="`pwd`"

	    echo $dir | tr '/' '\\'
	}

	export PS1='C:`msdos_pwd`> '

	echo "Microsoft Windows 2000 [Version 5.00]"
	echo "(C) Copyright 1985-2000 Microsoft Corp."
	echo

	export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libgtk3-nocsd.so.0

Your terminal should now look something like this: 

<img src="Screenshots/Terminal.png" alt="Terminal">


### Start menu:

Go to the menu-editor (often called menulibre)

Make it match this image:

<img src="Screenshots/Menulibre.png" alt="Menu">

*rename "Games" into "Shutdown..." and create a logut shortcut (xfce4-session-logout), rename "Office" into "Help", rename "Accesories" into "Programs".*

> ## Notes and cautions:

> Run most commands as your normal desktop user (not root) except where sudo is explicitly used. If gsettings or xfconf-query commands fail when run from a script or at login, ensure the commands run in your graphical session with DBUS_SESSION_BUS_ADDRESS set. Adjust monitor names in xfconf-query lines to match your system (use xfconf-query -c xfce4-desktop -l to inspect existing properties).

> I (The maintainer of MENT2K) won't take any responbility for broken systems. A restore point is recommended. Install MENT2K at your own risk.
