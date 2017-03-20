# Mastering Git

## Managing History

### `git log`
* Gives basic metadata on recent commits
* `git log --oneline` summarizes log to a single line
* `--decorate` Blue => HEAD (current check out), green => current branch, red => remote origin
* `--graph --all`, complete view of history with branches that have diverged and not made it back to master
* `git config --global alias.sla 'log --oneline --decorate --graph --all'` alias quoted command to `git sla`
* `--pretty=format: '%h - %an [%ar] %s'` %h => commit hash, %an => author name, %ar => relative date of commit, %s => short summary
* `git log --pretty=format:'%C(yellow)%h%C(reset) - %an [%C(green)%ar%C(reset)] %s'` similar command with colors
* `get help log` for more options
* `git log -E -i --grep 'cach(eing)'` (expanded regex, case insensitive)
* `git log -S with_active_subscription`, searches for commit changes the # of times it's used
* `git log --oneline -- Gemfile`, history of 1 specific file
* `git blame Gemfile`, who made change to file (sha, Author, date, change)
* `git show <sha-id>`, shows complete commit information including diff 

###
