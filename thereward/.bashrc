#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [[ -d ~/.bashrc.d ]]; then
  for file in ~/.bashrc.d/*.sh; do
    source "$file"
  done
fi

alias ls='ls --color=auto'

RED=$(tput setaf 1)
BOLD=$(tput bold)
RESET=$(tput sgr0)
function parse_retval {
  [ $? -ne 0 ] && echo "$RED"
}
function parse_git {
  branch=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
  if [ "${branch}" != "" ]; then
    bits=`parse_git_bits`
    if [ "${bits}" != "" ]; then
      echo "[${branch} ${bits}]"
    else
      echo "[${branch}]"
    fi
  else
    echo ""
  fi
}
function parse_git_bits {
  status=`git status 2>&1 | tee`
  ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
  diverged=`echo -n "${status}" 2> /dev/null | grep "have diverged" &> /dev/null; echo "$?"`
  dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
  renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
  newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
  deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
  untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
  if [ "${ahead}" == "0" ]; then
    echo -n "|"
  elif [ "${diverged}" == "0" ]; then
    echo -n "Y"
  fi
  if [ "${dirty}" == "0" ]; then
    echo -n "*"
  elif [ "${renamed}" == "0" ]; then
    echo -n "*"
  elif [ "${newfile}" == "0" ] && [ "${deleted}" == "0" ]; then
    echo -n "*"
  elif [ "${newfile}" == "0" ]; then
    echo -n "+"
  elif [ "${deleted}" == "0" ]; then
    echo -n "-"
  fi
  if [ "${untracked}" == "0" ]; then
    echo -n "?"
  fi
  echo "${bits}"
}
PS1="\[$BOLD\`parse_retval\`\]\u@\h \w\`parse_git\`\\$\[$RESET\] "
