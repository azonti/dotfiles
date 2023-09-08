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
  porcelain2branch=$(git status --porcelain=2 --branch 2> /dev/null)
  porcelain1=$(git status --porcelain=1 2> /dev/null)
  branch=$(parse_git_branch "${porcelain2branch}")
  if [ "${branch}" == "" ]; then
    echo ""
  else
    bits=$(parse_git_bits "${porcelain2branch}" "${porcelain1}")
    if [ "${bits}" == "" ]; then
      echo "[${branch}]"
    else
      echo "[${branch} ${bits}]"
    fi
  fi
}
function parse_git_branch {
  branch_head=$(echo "$1" | grep "^# branch.head" | cut -d " " -f 3)
  branch_oid=$(echo "$1" | grep "^# branch.oid" | cut -d " " -f 3)
  if [ "${branch_head}" == "(detached)" ]; then
    echo -n "detached at ${branch_oid:0:7}"
  else
    echo -n "${branch_head}"
  fi
}
function parse_git_bits {
  ahead=$(echo "$1" | grep "^# branch.ab" | cut -d " " -f 3)
  if [ ${ahead} -eq 0 ]; then
    echo -n ""
  else
    behind=$(echo "$1" | grep "^# branch.ab" | cut -d " " -f 4)
    if [ ${behind} -eq 0 ]; then
      echo -n "|"
    else
      echo -n "Y"
    fi
  fi
  modified_worktree=$(echo "$2" | grep "^M" | wc -l)
  modified_index=$(echo "$2" | grep "^.M" | wc -l)
  typechanged_worktree=$(echo "$2" | grep "^T" | wc -l)
  typechanged_index=$(echo "$2" | grep "^.T" | wc -l)
  added_worktree=$(echo "$2" | grep "^A" | wc -l)
  added_index=$(echo "$2" | grep "^.A" | wc -l)
  deleted_worktree=$(echo "$2" | grep "^D" | wc -l)
  deleted_index=$(echo "$2" | grep "^.D" | wc -l)
  renamed_worktree=$(echo "$2" | grep "^R" | wc -l)
  renamed_index=$(echo "$2" | grep "^.R" | wc -l)
  unmarged_us=$(echo "$2" | grep "^U" | wc -l)
  unmerged_them=$(echo "$2" | grep "^.U" | wc -l)
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
  untracked=$(echo "$2" | grep "^??" | wc -l)
  if [ ${untracked} -ne 0 ]; then
    echo -n "?"
  fi
}
PS1="\[$BOLD\`parse_retval\`\]\u@\h \w\`parse_git\`\\$\[$RESET\] "
