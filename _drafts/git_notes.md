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

## Undoing
* Note: you'll typically want to do this only in your own branch

* `git commit --amend --no-edit` add to previous commit, `--no-edit` won't open the text editor
* `git reset <filename>` will remove <filename> from being staged, without filename it will unstage everything currently staged
* `git checkout .` checkout current working directory, will remove previously changed files (this is destructive if you haven't committed files)
* `git reset --soft HEAD^` => `git config --global alias.uncommit 'reset --soft HEAD^'` HEAD is current branch checked out, ^ is the parent, --soft es that we should reset the branch (to point at that parent commit), but otherwise leave the files in the working directory and the index untouched.
* `git status --short`

## Crafting History with Rebase
* https://thoughtbot.com/upcase/videos/git-crafting-history
* `git add --patch` git will present an interface to look at each set of changes, so you can make a choice for each one

Key	| Operation
--- | ---
h |	Display the list of available keys and their operation
y |	Stage the current hunk
n |	Skip this hunk
s |	Split the hunk
a |	Stage this and all remaining hunks
q |	Quit, skipping all remaining hunks
e |	Edit the hunk manually, allowing for line be line staging

* `git diff --cached` shows the staged changes
* `git diff origin/master..master` shows changes for a range of commits from origin/master to master
* `git cherry-pick origin/master..master` copy commits onto a different branch, creates new commits instead of modifying the existing commits

* `git help rebase`
* `git rebase master`
> As an example, let's assume we have a branch that when started was based off of
> master. We've made some changes on our branch and now have two new commits, but
> at the same time our colleagues have also made changes on the master branch.
> When performing the rebase, Git finds the commits unique to our branch and
> computes the diff off the changes they introduced, then moves to the target
> branch, master in this case, and one by one applies the diffs, creating new
> commits reusing the commit messages from our branch. Once done, it updates our
> branch to point at the newest of these commits created by reapplying the diffs.

* `git rebase -i master`, interactive rebase allows you to squash multiple commits into a single commit
  * p, pick = use commit
  * r, reword = use commit, but edit the commit message
  * e, edit = use commit, but stop for amending
  * s, squash = use commit, but meld into previous commit
  * f, fixup = like "squash", but discard this commit's log message
  * x, exec = run command using shell
