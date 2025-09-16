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
alias gamend='git commit --amend --no-edit'
alias greset='git reset --hard origin/$(git rev-parse --abbrev-ref HEAD)'
alias gco='git checkout'
alias gcm='git checkout main'
alias gb='git branch'
alias gstash='git stash push -u && git stash list | head -n 1'
alias gpop='git stash pop'
alias gdrop='git stash drop stash@{0}'
alias gundoall='git reset --hard HEAD && git clean -fd'
alias gfix='git commit --fixup'
alias gpr='gh pr create --fill'
alias gprv='gh pr view --web'
alias gprc='gh pr checkout'
alias gprm='gh pr merge --squash --delete-branch'
alias gclone='gh repo clone'
alias gnew='git checkout -b'
alias gdel='git branch -d'
alias gcp='git cherry-pick'


