# .bash_aliases

# --- Sync & Update ---
alias gpull='git fetch origin && git pull'
alias grebase='git pull --rebase --autostash'
alias gclean='git fetch --prune && git branch -vv'
alias greset='git fetch origin && git reset --hard origin/$(git rev-parse --abbrev-ref HEAD)'

# --- Commit & Push ---
gpush() {
  git add .
  git commit -m "${1:-update}"
  git push
}
alias gammend='git commit --amend --no-edit'
alias gfix='git commit --fixup'

# --- Status & History ---
alias gstat='git status -sb'
alias glog='git log --oneline --graph --decorate -n 10'
alias ghist='git reflog --date=short --pretty=oneline'
alias gdiff='git diff --color-words'
alias gshow='git show HEAD --stat --color'

# --- Branching ---
alias gb='git branch'
alias gco='git checkout'
alias gcm='git checkout main'
alias gnew='git checkout -b'
alias gdel='git branch -d'
alias gblame='git blame -c'

# --- Undo / Reset ---
alias gundo='git reset --soft HEAD~1'
alias gundoall='git reset --hard HEAD && git clean -fd'

# --- Stash Cycle ---
alias gstash='git stash push -u && git stash list | head -n 1'
alias gpop='git stash pop'
alias gdrop='git stash drop stash@{0}'

# --- Tags & Releases ---
alias gtag='git tag -a'
alias gtags='git tag --list --sort=-creatordate | head -n 10'
alias gpush-tags='git push --tags'

# --- Cherry-pick / Patch ---
alias gcp='git cherry-pick'
alias gpatch='git format-patch -1 HEAD'

# --- GitHub PR Lifecycle (requires gh CLI) ---
alias gpr='gh pr create --fill'
alias gprv='gh pr view --web'
alias gprc='gh pr checkout'
alias gprm='gh pr merge --squash --delete-branch'

# --- GitHub Repo Ops ---
alias gclone='gh repo clone'

# --- Interactive Helpers ---
gri() {
  git rebase -i HEAD~${1:-3}
}
gignore() {
  echo "$1" >> .gitignore
  git add .gitignore
  echo "Added '$1' to .gitignore"
}

# --- Help ---
ghelp() {
  cat <<'EOF'
Git Alias Cheat-Sheet:

Sync & Update:
  gpull       - fetch + pull
  grebase     - pull with rebase + autostash
  gclean      - prune remote branches, show local
  greset      - hard reset to origin/<branch>

Commit & Push:
  gpush [msg] - add, commit, push (default msg "update")
  gammend     - amend last commit (no message change)
  gfix <hash> - fixup commit for autosquash

Status & History:
  gstat       - short status
  glog        - last 10 commits (graph)
  ghist       - reflog (short date)
  gdiff       - inline diff
  gshow       - show last commit details

Branching:
  gb          - list branches
  gco <br>    - checkout branch
  gcm         - checkout main
  gnew <br>   - create + switch branch
  gdel <br>   - delete branch
  gblame <f>  - blame file (compact)

Undo / Reset:
  gundo       - undo last commit, keep changes
  gundoall    - discard all changes
  greset      - hard reset to remote

Stash Cycle:
  gstash      - stash all (tracked+untracked)
  gpop        - apply last stash
  gdrop       - drop last stash

Tags & Releases:
  gtag <v>    - create tag
  gtags       - list last 10 tags
  gpush-tags  - push tags

Cherry-pick / Patch:
  gcp <hash>  - cherry-pick commit
  gpatch      - export last commit as patch

GitHub PR Lifecycle (gh CLI):
  gpr         - create PR
  gprv        - view PR in browser
  gprc <id>   - checkout PR
  gprm <id>   - merge PR (squash + delete branch)

GitHub Repo Ops:
  gclone <r>  - clone repo

Interactive Helpers:
  gri [N]     - interactive rebase last N commits (default 3)
  gignore <f> - add file/pattern to .gitignore + stage

EOF
}