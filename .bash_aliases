# .bash_aliases

# Git shortcuts
alias gpull='git fetch origin && git pull'

gpush() {
  git add .
  git commit -m "${1:-update}"
  git push
}

alias gstat='git status -sb'
alias glog='git log --oneline --graph --decorate -n 10'
alias grebase='git pull --rebase --autostash'
alias gclean='git fetch --prune && git branch -vv'
alias gundo='git reset --soft HEAD~1'
alias ghist='git reflog --date=short --pretty=oneline'
alias gdiff='git diff --color-words'
