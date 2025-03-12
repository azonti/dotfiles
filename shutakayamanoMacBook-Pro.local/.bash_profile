#
# ~/.bash_profile
#

if [[ -d ~/.profile.d ]]; then
  for file in ~/.profile.d/*.c.sh; do
    source "$file"
  done
fi

ulimit -n 2048

[[ -f ~/.bashrc ]] && . ~/.bashrc
