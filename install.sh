#!/bin/sh

print_head() {
    local text="$1"
    echo ""
    echo "-----------------------------"
    echo "$text"
    echo "-----------------------------"
    echo ""
    read -p "Press any key to continue..."
    echo ""
}

get_ownership() {
    local file_to_set=$1
    sudo chown -R $USER:$USER $file_to_set
}

SRC_DIR=$(pwd)


print_head "Installing Updates..."
sudo dnf update -y; sudo dnf upgrade -y;
sudo dnf -y install dnf-plugins-core

print_head "Installing Packages..."
sudo dnf install -y zsh vlc neovim unzip neofetch gnome-tweaks gnome-themes-extra btop git golang inkscape xorg-x11-apps wget curl tmux

sudo dnf erase fzf

print_head "Setting Gnome Theme..."
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

dconf load /org/gnome/terminal/legacy/profiles:/ < $SRC_DIR/src/gnome-terminal-profiles.dconf

mkdir -p /home/$USER/Pictures/wallapers/
sudo cp $SRC_DIR/src/wallpaper/* /home/$USER/Pictures/wallapers/
sudo cp $SRC_DIR/src/profile-pic/profile.png /home/$USER/Pictures/profile.png

sleep 3

print_head "Setting User Profile To Cartoony Fox"

USERNAME="$USER"
PROFILE_PIC_PATH="/home/$USERNAME/Pictures/profile.png"
ACCOUNTS_SERVICE_PATH="/var/lib/AccountsService/icons/$USERNAME"

# Set the user profile picture
sudo dbus-send --system --print-reply --dest=org.freedesktop.Accounts \
    /org/freedesktop/Accounts/User$(id -u $USERNAME) \
    org.freedesktop.Accounts.User.SetIconFile \
    string:"$PROFILE_PIC_PATH"

# Wait a bit to ensure the profile picture is copied
sleep 1

# Check if the destination file exists
if [ -f "$ACCOUNTS_SERVICE_PATH" ]; then
    # Calculate checksums
    ORIGINAL_CHECKSUM=$(sha256sum "$PROFILE_PIC_PATH" | awk '{ print $1 }')
    COPIED_CHECKSUM=$(sudo sha256sum "$ACCOUNTS_SERVICE_PATH" | awk '{ print $1 }')

    # Print debug information
    echo "Original checksum: $ORIGINAL_CHECKSUM"
    echo "Copied checksum: $COPIED_CHECKSUM"

    # Compare the checksums
    if [ "$ORIGINAL_CHECKSUM" == "$COPIED_CHECKSUM" ]; then
        echo "Profile picture set successfully for user $USERNAME."
    else
        echo "Failed to set profile picture for user $USERNAME. Checksums do not match."
    fi
else
    echo "Failed to set profile picture for user $USERNAME. Destination file not found."
fi


print_head "Setting Mouse Size..."
gsettings set org.gnome.desktop.interface cursor-size 48

print_head "Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

. /home/$USER/.bashrc

print_head "Installing Docker..."
# install docker
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker "$(logname)"
sudo systemctl enable --now docker

. /home/$USER/.bashrc

print_head "Installing HomeBrew..."
## Install dependencies for homebrew
sudo dnf group -y install 'Development Tools'
sudo dnf -y install procps-ng curl file git

## Install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

## Add homebrew to $PATH and ~/.bash_profile
test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
test -r ~/.bash_profile && echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.bash_profile
echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.profile
. /home/$USER/.bashrc
brew install fzf

print_head "Installing PyEnv..."
curl https://pyenv.run | bash
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> /home/$USER/.profile
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> /home/$USER/.profile
echo 'eval "$(pyenv init --path)"' >> /home/$USER/.profile

. /home/$USER/.bashrc

print_head "Installing Flatpak Applications..."

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

flatpak install -y flathub org.telegram.desktop
flatpak install -y flathub org.signal.Signal
flatpak install -y flathub io.httpie.Httpie
flatpak install -y flathub com.visualstudio.code
flatpak install -y flathub org.signal.signal
flatpak install -y flathub com.spotify.Client
flatpak install -y flathub com.bitwarden.desktop
flatpak install -y flathub com.discordapp.Discord
flatpak install -y flathub com.obsproject.Studio
flatpak install -y flathub com.mattjakeman.ExtensionManager
flatpak install -y flathub org.gnome.Loupe
flatpak install -y flathub com.ktechpit.whatsie
flatpak install -y flathub org.torproject.torbrowser-launcher
flatpak install -y flathub io.github.peazip.PeaZip
flatpak install -y flathub com.protonvpn.www
flatpak install -y flathub com.slack.Slack
flatpak install -y flathub com.google.AndroidStudio
flatpak install -y flathub io.github.shiftey.Desktop
flatpak install -y flathub nl.hjdskes.gcolor3
flatpak install -y flathub org.kde.audiotube

. /home/$USER/.bashrc

print_head "Installing Capitaine Cursor Mouse..."
# Captain capitaine-cursors
sudo dnf copr enable tcg/themes
sudo dnf install la-capitaine-cursor-theme

print_head "Installing Desert Brown Dark Theme..."
#install deser theme
mkdir -p /home/$USER/.themes/
sudo cp -r $SRC_DIR/src/Desert-Brown-Dark-1.3 /home/$USER/.themes/
gsettings set org.gnome.desktop.interface gtk-theme 'Desert-Brown-Dark-1.3'

print_head "Installing Tela Circle Icons..."

# install tela icons
git clone https://github.com/vinceliuice/Tela-icon-theme.git $SRC_DIR/src/Tela-icon-theme
sudo chmod +x $SRC_DIR/src/Tela-icon-theme/install.sh
sudo sh $SRC_DIR/src/Tela-icon-theme/install.sh -a
gsettings set org.gnome.desktop.interface icon-theme "Tela-circle-manjaro-dark"


print_head "Installing Oh-My-Zsh..."
# ohmyzsh install
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

print_head "Installing zsh-syntax-highlighting..."
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /home/$USER/.zsh-syntax-highlighting

print_head "Setting ZSH, Neofetch, Neovim and Alliases"
sudo cp -f $SRC_DIR/src/.zshrc /home/$USER/.zshrc
sudo cp -f $SRC_DIR/src/.zshrc_history /home/$USER/.zshrc_history
sudo cp -f $SRC_DIR/src/.bash_aliases /home/$USER/.bash_aliases
sudo cp -f $SRC_DIR/src/.p10k.zsh /home/$USER/.p10k.zsh
sudo cp -f $SRC_DIR/.zshrc.pre-oh-my-zsh /home/$USER/.zshrc.pre-oh-my-zsh

print_head "Setting NeoFetch and NeoVim Configs..."
if [ -d "/home/$USER/.config/nvim/" ]; then
    echo "Removing existing directory: /home/$USER/.config/nvim/"
    rm -rf "/home/$USER/.config/nvim/"
fi

git clone https://github.com/drunkleen/My-NeoVim-Config.git /home/$USER/.config/nvim

sudo cp -f $SRC_DIR/src/neofetch/ascii.txt /home/$USER/.config/neofetch/ascii.txt
sudo cp -f $SRC_DIR/src/neofetch/config.conf /home/$USER/.config/neofetch/config.conf
get_ownership "/home/$USER/.config/neofetch/"

print_head "Installing NodeJs and NVM..."
sudo dnf install -y nodejs npm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

print_head "Installing Nerd Fonts..."
# Fonts
wget -P /home/$USER/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip \
&& unzip /home/$USER/.local/share/fonts/JetBrainsMono.zip \
&& rm home/$USER/.local/share/fonts/JetBrainsMono.zip

wget -P /home/$USER/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Hack.zip \
&& unzip /home/$USER/.local/share/fonts/Hack.zip \
&& rm home/$USER/.local/share/fonts/Hack.zip \
&& fc-cache -fv

print_head "Installing Custom Grub..."

git clone https://github.com/drunkleen/starwars-grub.git $SRC_DIR/src/starwars-grub
chmod +x $SRC_DIR/src/starwars-grub/install.sh
sudo $SRC_DIR/src/starwars-grub/install.sh -s 2k


sl
echo ""
echo ""
echo "System will reboot now."
read -p "Press Enter to Reboot..."
sudo reboot


