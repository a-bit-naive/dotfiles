# package manager
abbr -a xbpi "sudo xbps-install -Syu"
abbr -a xbpr "sudo xbps-remove"
abbr -a xbpq "sudo xbps-query"

# general commands
abbr -a ll "ls -l"
abbr -a l "ls"
abbr -a c "cd"
abbr -a cp "cp -r"

# adds back sudo !! cause i miss it
abbr -a !! --position anywhere --function last_history_item

# git
abbr -a gi "git init"
abbr -a gs "git status"
abbr -a ga "git add"
abbr -a gcm --set-cursor 'git commit -m "%"'
abbr -a gp "git push"
abbr -a "git log --oneline --graph"
abbr -a gr "git revert"
