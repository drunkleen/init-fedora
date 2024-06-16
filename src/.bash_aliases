alias vim="nvim"

alias install="sudo dnf install $1 $2 $3 $4 $5"
alias remove="sudo dnf erase $1 $2 $3 $4 $5"
alias update="sudo dnf update -y; sudo dnf upgrade -y"

alias open="xdg-open $1"
alias opendir="nautilus ."
