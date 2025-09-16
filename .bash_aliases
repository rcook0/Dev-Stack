# .bash_aliases

# Git shortcuts
alias gpull='git fetch origin && git pull'
gpush() {
  git add .
  git commit -m "${1:-update}"
  git push
}
alias gstat='git status -sb'
