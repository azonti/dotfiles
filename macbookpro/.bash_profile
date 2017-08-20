#
# ~/.bash_profile
#

if [[ -d ~/.profile.d ]]; then
  for file in ~/.profile.d/*.c.sh; do
    source "$file"
  done
fi

[[ -f ~/.bashrc ]] && . ~/.bashrc
