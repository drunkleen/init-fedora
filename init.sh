#!/bin/sh
echo "\n\n-----------------------------"
echo "Installing Updates..."
echo "-----------------------------\n"
read -p "Press Enter to continue..."
sudo dnf update -y; sudo dnf upgrade -y;
sudo dnf -y install dnf-plugins-core


echo "\n\n-----------------------------"
echo "Installing Packages..."
echo "-----------------------------\n"
read -p "Press Enter to continue..."
sudo dnf install zsh vlc neovim fzf neofetch gnome-tweaks gnome-themes-extra btop git golang inkscape xorg-x11-apps wget -y


echo "\n\n-----------------------------"
echo "Setting Gnome Theme..."
echo "-----------------------------\n"
read -p "Press Enter to continue..."
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

echo "\n\n-----------------------------"
echo "Setting Gnome Extentions and Terminal Profile..."
echo "-----------------------------\n"
read -p "Press Enter to continue..."
sudo dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf update -y
sudo dnf install -y fedora-workstation-repositories
sudo dnf install -y gnome-extensions-app
sudo dnf install gnome-browser-connector
gnome-shell-extension-tool -d background-logo@fedorahosted.org
dconf load /org/gnome/terminal/legacy/profiles:/ < /home/$USER/Downloads/init-fedora/src/gnome-terminal-profiles.dconf

echo "\n\n-----------------------------"
echo "Setting Mouse Size..."
echo "-----------------------------\n"
read -p "Press Enter to continue..."
gsettings set org.gnome.desktop.interface cursor-size 48

echo "\n\n-----------------------------"
echo "Installing Rust..."
echo "-----------------------------\n"
read -p "Press Enter to continue..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

source /home/$USER/.bashrc

echo "\n\n-----------------------------"
echo "Installing Docker..."
echo "-----------------------------\n"
read -p "Press Enter to continue..."
# install docker
sudo dnf config-manager \
  --add-repo \
  https://download.docker.com/linux/fedora/docker-ce.repo

sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker "$(logname)"

sudo systemctl enable --now docker


source /home/$USER/.bashrc


echo "\n\n-----------------------------"
echo "Installing HomeBrew..."
echo "-----------------------------\n"
read -p "Press Enter to continue..."
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

source /home/$USER/.bashrc

curl https://pyenv.run | bash

source /home/$USER/.bashrc


echo "\n\n-----------------------------"
echo "Installing Flatpak Applications..."
echo "-----------------------------\n"
read -p "Press Enter to continue..."

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

flatpak install flathub org.telegram.desktop
flatpak install flathub org.signal.Signal
flatpak install flathub io.httpie.httpie
flatpak install flathub com.visualstudio.code
flatpak install flathub org.signal.signal
flatpak install flathub com.spotify.Client
flatpak install flathub com.bitwarden.desktop
flatpak install flathub com.discordapp.Discord
flatpak install flathub com.obsproject.Studio
flatpak install flathub com.mattjakeman.ExtensionManager
flatpak install flathub org.gnome.Loupe
flatpak install flathub com.ktechpit.whatsie
flatpak install flathub org.torproject.torbrowser-launcher
flatpak install flathub io.github.peazip.PeaZip
flatpak install flathub com.protonvpn.www
flatpak install flathub com.slack.Slack
flatpak install flathub com.google.AndroidStudio
flatpak install flathub io.github.shiftey.Desktop
flatpak install flathub nl.hjdskes.gcolor3
flatpak install flathub org.kde.audiotube


source /home/$USER/.bashrc

echo "\n\n-----------------------------"
echo "Installing Capitaine Cursor Mouse..."
echo "-----------------------------\n"
read -p "Press Enter to continue..."
# Captain capitaine-cursors
git clone https://github.com/keeferrourke/capitaine-cursors.git /home/$USER/Downloads/capitaine/

chmod +x /home/$USER/Downloads/capitaine/build.sh
/home/$USER/Downloads/capitaine/build.sh
sudo sh /home/$USER/Downloads/capitaine/build.sh

echo "\n\n-----------------------------"
echo "Installing Desert Brown Dark Theme..."
echo "-----------------------------\n"
read -p "Press Enter to continue..."
#install deser theme
mkdir /home/$USER/.themes/
sudo cp /home/$USER/Downloads/init-fedora/src/Desert-Brown-Dark-1.3 /home/$USER/.themes/

# install tela icons
git clone https://github.com/vinceliuice/Tela-icon-theme.git /home/$USER/Downloads/Tela-icon-theme
sudo chmod +x /home/$USER/Downloads/Tela-icon-theme/install.sh
sudo sh /home/$USER/Downloads/Tela-icon-theme/install.sh -a

echo "\n\n-----------------------------"
echo "Installing Oh-My-Zsh..."
echo "-----------------------------\n"
read -p "Press Enter to continue..."
# ohmyzsh install
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "\n\n-----------------------------"
echo "Installing zsh-syntax-highlighting..."
echo "-----------------------------\n"
read -p "Press Enter to continue..."
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /home/$USER/.zsh-syntax-highlighting



echo "\n\n-----------------------------"
echo "Setting ZSH and Aliases..."
echo "-----------------------------\n"
read -p "Press Enter to continue..."
sudo cp -f /home/$USER/Downloads/init-fedora/src/.zshrc /home/$USER/.zshrc
sudo cp -f /home/$USER/Downloads/init-fedora/src/.zshrc_history /home/$USER/.zshrc_history
sudo cp -f /home/$USER/Downloads/init-fedora/src/.bash_aliases /home/$USER/.bash_aliases
sudo cp -f /home/$USER/Downloads/init-fedora/src/.p10k.zsh /home/$USER/.p10k.zsh
sudo cp -f /home/$USER/Downloads/init-fedora/src/.zshrc.pre-oh-my-zsh /home/$USER/.zshrc.pre-oh-my-zsh


echo "\n\n-----------------------------"
echo "Setting NeoFetch and NeoVim Configs..."
echo "-----------------------------\n"
read -p "Press Enter to continue..."

sudo cp -rf /home/$USER/Downloads/init-fedora/src/nvim /home/$USER/.config/
sudo cp -f /home/$USER/Downloads/init-fedora/src/neofetch /home/$USER/.config/neofetch


echo "\n\n-----------------------------"
echo "Installing Nerd Fonts..."
echo "-----------------------------\n"
read -p "Press Enter to continue..."
# Fonts
wget -P /home/$USER/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip \
&& cd /home/$USER/.local/share/fonts \
&& unzip JetBrainsMono.zip \
&& rm JetBrainsMono.zip

wget -P /home/$USER/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Hack.zip \
&& cd /home/$USER/.local/share/fonts \
&& unzip Hack.zip \
&& rm Hack.zip \
&& fc-cache -fv


echo "\n\n-----------------------------"
echo "Installing Custom Grub..."
echo "-----------------------------\n"
read -p "Press Enter to continue..."
sudo chmod +x /home/$USER/Downloads/init-fedora/src/rog-grub/install.sh
sudo sh /home/$USER/Downloads/init-fedora/src/rog-grub/install.sh -s 2k


read -p "Press Enter to continue..."




