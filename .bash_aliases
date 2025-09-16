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
git fetch --prune && git branch -vv
