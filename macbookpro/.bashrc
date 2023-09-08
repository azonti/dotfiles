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
  branch=$(parse_git_branch "$(git status --porcelain=2 --branch 2> /dev/null)")
  if [ "${branch}" == "" ]; then
    echo ""
  else
    bits=$(parse_git_bits "$(git status --porcelain=1 2> /dev/null)")
    if [ "${bits}" == "" ]; then
      echo "[${branch}]"
    else
      echo "[${branch} ${bits}]"
    fi
  fi
}
function parse_git_branch {
  branch_head=$(echo "$1" | grep "^# branch.head" | cut -d " " -f 3)
  if [ "${branch_head}" == "" ]; then
    echo -n ""
  elif [ "${branch_head}" == "(detached)" ]; then
    branch_oid=$(echo "$1" | grep "^# branch.oid" | cut -d " " -f 3)
    echo -n "detached at ${branch_oid:0:7}"
  else
    ahead=$(echo "$1" | grep "^# branch.ab" | cut -d " " -f 3)
    if [ ${ahead} -eq 0 ]; then
      echo -n "${branch_head}"
    else
      behind=$(echo "$1" | grep "^# branch.ab" | cut -d " " -f 4)
      if [ ${behind} -eq 0 ]; then
        echo -n "${branch_head} |"
      else
        echo -n "${branch_head} Y"
      fi
    fi
  fi
}
function parse_git_bits {
  modified_worktree=$(echo "$1" | grep "^M" | wc -l)
  modified_index=$(echo "$1" | grep "^.M" | wc -l)
  typechanged_worktree=$(echo "$1" | grep "^T" | wc -l)
  typechanged_index=$(echo "$1" | grep "^.T" | wc -l)
  added_worktree=$(echo "$1" | grep "^A" | wc -l)
  added_index=$(echo "$1" | grep "^.A" | wc -l)
  deleted_worktree=$(echo "$1" | grep "^D" | wc -l)
  deleted_index=$(echo "$1" | grep "^.D" | wc -l)
  renamed_worktree=$(echo "$1" | grep "^R" | wc -l)
  renamed_index=$(echo "$1" | grep "^.R" | wc -l)
  unmarged_us=$(echo "$1" | grep "^U" | wc -l)
  unmerged_them=$(echo "$1" | grep "^.U" | wc -l)
  if [ ${modified_worktree} -ne 0 ] || [ ${modified_index} -ne 0 ] ||
     [ ${typechanged_worktree} -ne 0 ] || [ ${typechanged_index} -ne 0 ] ||
     [ ${renamed_worktree} -ne 0 ] || [ ${renamed_index} -ne 0 ] ||
     [ ${unmarged_us} -ne 0 ] || [ ${unmerged_them} -ne 0 ]; then
    echo -n "*"
  elif { [ ${added_worktree} -ne 0 ] || [ ${added_index} -ne 0 ]; } &&
       { [ ${deleted_worktree} -ne 0 ] || [ ${deleted_index} -ne 0 ]; }; then
    echo -n "*"
  elif [ ${added_worktree} -ne 0 ] || [ ${added_index} -ne 0 ]; then
    echo -n "+"
  elif [ ${deleted_worktree} -ne 0 ] || [ ${deleted_index} -ne 0 ]; then
    echo -n "-"
  fi
  untracked=$(echo "$1" | grep "^??" | wc -l)
  if [ ${untracked} -ne 0 ]; then
    echo -n "?"
  fi
}
PS1="\[$BOLD\`parse_retval\`\]\u@\h \w\`parse_git\`\\$\[$RESET\] "
